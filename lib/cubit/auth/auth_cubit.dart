import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riviera23/presentation/methods/custom_flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../presentation/methods/snack_bar.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._auth) : super(AuthLoading()) {
    // call this method to check if the user is already signed in
  }

  final FirebaseAuth _auth;

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  Future<bool> checkAlreadySignedIn() async {
    emit(AuthLoading());
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        print("User is signed in");
        print(user.providerData[0].providerId);

        if (user.providerData[0].providerId == 'password') {
          if (!user.emailVerified) {
            await _auth.signOut();
            emit(NotSignedInState());
            return false;
          } else {
            emit(SignInSuccess(currentUser: user));
            return true;
          }
        } else {
          emit(SignInSuccess(currentUser: user));
          return true;
        }
      } else {
        print("User is not signed in");
        emit(NotSignedInState());
        return false;
      }
    } catch (e) {
      emit(NotSignedInState());
      debugPrint(e.toString());
      return false;
    }
  }

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
      emit(NotSignedInState());
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showCustomFlushbar("The password provided is too weak.", "Please Enter a stronger password", context);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showCustomFlushbar("Account already exists", "The account already exists for that email.", context);
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
      emit(NotSignedInState());
    }
  }

  // EMAIL LOGIN
  Future<dynamic> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
        emit(NotSignedInState());
        return null;
      }
      emit(SignInSuccess(currentUser: userCredential.user!));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomFlushbar("No user found",
            "This email address has not been registered.", context);
      } else if (e.code == 'wrong-password') {
        showCustomFlushbar("Authentication Failed!",
            "Wrong Password provided for the current email.", context);
      }
      showSnackBar(context, e.message!);
      emit(NotSignedInState());
      return null; // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showCustomFlushbar(
          "Email Verification Sent!",
          "Please check your inbox or spam folder for verification link",
          context);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  Future<dynamic> signInWithGoogle(BuildContext context) async {
    emit(AuthLoading());
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn _googleSignIn = GoogleSignIn();
      // Trigger the authentication flow
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final firebaseCredential = await auth.signInWithCredential(credential);
      emit(SignInSuccess(currentUser: firebaseCredential.user!));
      return firebaseCredential;
    } on FirebaseAuthException catch (e) {
      emit(NotSignedInState());
      showSnackBar(context, e.message!); // Displaying the error message
      return null;
    }
  }

  Future<dynamic> signInWithApple(BuildContext context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    emit(AuthLoading());
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential firebaseCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      emit(SignInSuccess(currentUser: firebaseCredential.user!));
      return await firebaseCredential.user!.getIdToken(true);
    } on FirebaseAuthException catch (e) {
      emit(NotSignedInState());
      showSnackBar(context, e.message!);
      return null;
    }
  }

  Future<bool> signOut(BuildContext context) async {
    try {
      print("authentication method is  ${user.providerData[0].providerId}");
      if (user.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().signOut();
      } else if (user.providerData[0].providerId == 'apple.com') {
        //await Apple.instance.logOut();
      } else {}

      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      return false;
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

}
