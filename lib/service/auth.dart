import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../presentation/methods/showSnackBar.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

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
    try {

      if(FirebaseAuth.instance.currentUser != null) {

        print("User is signed in");
        return true;
      } else {
        print("User is not signed in");
        return false;
      }
    } catch (e) {
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
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }



  Future<void> signInWithGoogle(BuildContext context) async {
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

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  /*
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;*/

  /* // Shared State for Widgets
  Stream<User> user; // firebase user
  Stream<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();
*/
/*  // constructor
  AuthService() {
    user = Stream(_auth.authStateChanges());

    profile = user.switchMap((User u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });

  }*/
/*
  Future<FirebaseUser> googleSignIn() async {
    // Start
    loading.add(true);

    // Step 1
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Step 3
    updateUserData(user);

    // Done
    loading.add(false);
    print("signed in " + user.displayName);
    return user;
  }*/

  /*void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }*/



  Future<bool> signOut(BuildContext context) async {
    try {
      print("authentication method is  ${user.providerData[0].providerId}");
      if (user.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().signOut();
      } else if (user.providerData[0].providerId == 'apple.com') {
        //await Apple.instance.logOut();
      } else {

      }

      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      return false;
    }
  }
}
