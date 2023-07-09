import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riviera23/presentation/methods/custom_flushbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../utils/constants/strings/strings.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<bool> checkAlreadySignedIn() async {
    emit(AuthLoading());
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        if (user.providerData[0].providerId == Strings.password) {
          if (!user.emailVerified) {
            await _auth.signOut();
            emit(NotSignedInState());
            return false;
          } else {
            emit(SignInSuccess(user: user));
            return true;
          }
        } else {
          emit(SignInSuccess(user: user));
          return true;
        }
      } else {
        emit(NotSignedInState());
        return false;
      }
    } catch (e) {
      emit(NotSignedInState());
      return false;
    }
  }

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
      if (e.code == Strings.weakPassword) {
        showCustomFlushbar(
            Strings.weakPasswordTitle, Strings.weakPasswordMessage, context);
        emit(NotSignedInState());
      } else if (e.code == Strings.emailInUse) {
        showCustomFlushbar(
            Strings.emailInUseTitle, Strings.emailInUseMessage, context);
        emit(NotSignedInState());
      }
      showCustomFlushbar(Strings.generalErrorTitle, e.message!, context);
      emit(NotSignedInState()); // Displaying the usual firebase error message
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
        emit(NotSignedInState());
        return null;
      }
      emit(SignInSuccess(user: user));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == Strings.userNotFound) {
        showCustomFlushbar(
            Strings.userNotFoundTitle, Strings.userNotFoundMessage, context);
        emit(NotSignedInState());
      } else if (e.code == Strings.wrongPassword) {
        showCustomFlushbar(
            Strings.wrongPasswordTitle, Strings.wrongPasswordMessage, context);
        emit(NotSignedInState());
      }
      showCustomFlushbar(Strings.generalErrorTitle, e.message!, context);
      emit(NotSignedInState());
      return null;
    }
  }

  // EMAIL VERIFICATION
  Future<dynamic> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showCustomFlushbar(Strings.emailVerificationTitle,
          Strings.emailVerificationMessage, context);
    } on FirebaseAuthException catch (e) {
      showCustomFlushbar(Strings.generalErrorTitle, e.message!,
          context); // Display error message
    }
  }

  Future<bool> sendResetPasswordEmail(
      String email, BuildContext context) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(NotSignedInState());
      showCustomFlushbar(
          Strings.passwordResetTitle, Strings.passwordResetMessage, context);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == Strings.badEmailFormat) {
        showCustomFlushbar(Strings.badEmailFormatTitle,
            Strings.badEmailFormatMessage, context);
        emit(NotSignedInState());
      } else if (e.code == Strings.userNotFound) {
        showCustomFlushbar(
            Strings.userNotFoundTitle, Strings.userNotFoundMessage, context);
        emit(NotSignedInState());
      } else {
        showCustomFlushbar(Strings.generalErrorTitle, e.message!, context);
        emit(NotSignedInState());
      }
      emit(NotSignedInState());
      return false;
    }
  }

  Future<dynamic> signInWithGoogle(BuildContext context) async {
    emit(AuthLoading());
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn googleSignIn = GoogleSignIn();

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        emit(NotSignedInState());
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final firebaseCredential = await auth.signInWithCredential(credential);
      emit(SignInSuccess(user: user));
      return firebaseCredential;
    } on FirebaseAuthException catch (e) {
      showCustomFlushbar(Strings.generalErrorTitle, e.message!,
          context); // Displaying the error message
      emit(NotSignedInState());
      return null;
    }
  }

  Future<dynamic> signInWithApple(BuildContext context) async {
    emit(AuthLoading());
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider(Strings.apple).credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential firebaseCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      emit(SignInSuccess(user: user));
      return await firebaseCredential.user!.getIdToken(true);
    } on FirebaseAuthException catch (e) {
      showCustomFlushbar(Strings.generalErrorTitle, e.message!, context);
      emit(NotSignedInState());
      return null;
    }
  }

  Future<bool> signOut(BuildContext context) async {
    try {
      if (user.providerData[0].providerId == Strings.google) {
        await GoogleSignIn().signOut();
      }

      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      showCustomFlushbar(Strings.generalErrorTitle, e.message!,
          context); // Displaying the error message
      return false;
    }
  }

  String generateNonce([int length = 32]) {
    const charset = Strings.charset;
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
