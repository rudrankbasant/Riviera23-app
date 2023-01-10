import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riviera23/presentation/methods/custom_flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/methods/snack_bar.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());

  FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;


  void checkAlreadySignedIn() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        print("User is signed in");
        emit(SignInSuccess());
      } else {
        print("User is not signed in");
        emit(NotSignedInState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(NotSignedInState());
    }
  }


  void signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);

    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        showCustomFlushbar("Weak Password!", "Please type in a stronger password", context);
      } else if (e.code == 'email-already-in-use') {
        showCustomFlushbar("Account Already Exists", "This email is already in use, please login instead.", context);
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }


  // EMAIL LOGIN
  void loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
        return null;
      }
      emit(SignInSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomFlushbar("No user found", "This email address has not been registered.", context);
      } else if (e.code == 'wrong-password') {
        showCustomFlushbar("Authentication Failed!", "Wrong Password provided for the current email.", context);
      }
      showSnackBar(context, e.message!);
      emit(NotSignedInState());// Displaying the error message
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showCustomFlushbar("Email Verification Sent!","Please check your inbox or spam folder for verification link", context );

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }



  Future<dynamic> signInWithGoogle(BuildContext context) async {
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
      return firebaseCredential;

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      return null;

    }
  }



  Future<bool> signOut(BuildContext context) async {
    try {
      print("authentication method is  ${user.providerData[0].providerId}");
      if (user.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().signOut();
      } else if (user.providerData[0].providerId == 'apple.com') {
        //await Apple.instance.logOut();'
      } else {}

      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      return false;
    }
  }



}
