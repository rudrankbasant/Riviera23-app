import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riviera23/presentation/screens/auth_screen.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';

import '../../service/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkifUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/splash_screen.png', fit: BoxFit.cover)),
    );
  }

  Future<void> checkifUserLoggedIn() async {
    bool isLoggedIn =
        await AuthService(FirebaseAuth.instance).checkAlreadySignedIn();

    if (isLoggedIn) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavScreen())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AuthScreen())));
    }
  }
}
