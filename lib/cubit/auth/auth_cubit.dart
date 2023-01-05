import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());

  void checkAlreadySignedIn() async {
    try {
      SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
      bool _isLoggedIn = sharedPreferences.getBool("isLoggedIn") ?? false;
      //String _idToken = sharedPreferences.getString("idToken") ?? "";
      if (_isLoggedIn) {
        //debugPrint("saved token: ");
        //debugPrint(_idToken);
        signInAsync(await FirebaseAuth.instance.currentUser!.getIdToken());
      } else {
        emit(NotSignedInState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(NotSignedInState());
    }
  }

  void googleSignIn() async {
    emit(AuthLoading());
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn _googleSignIn = GoogleSignIn();
      // Trigger the authentication flow
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebaseCredential = await auth.signInWithCredential(credential);
      String idToken = await firebaseCredential.user!.getIdToken(true);


      //signInAsync(recreatedToken);
    } catch (e) {
      emit(NotSignedInState());
    }
  }


}

