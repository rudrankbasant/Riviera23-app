import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';
import 'package:riviera23/service/auth.dart';

import '../../utils/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/auth_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image.asset("assets/riviera_icon.png"),
            Text("Welcome to Riviera 23",
                style: AppTheme.appTheme.textTheme.headline6),
            SignInButton(
              Buttons.Google,
              onPressed: () => {
                AuthService(FirebaseAuth.instance).signInWithGoogle(context).then(
                    (value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavScreen()))

                )
              },
            ),
            SignInButton(
              Buttons.Apple,
              onPressed: () {
              },
            )
          ],
        ) ,
      ),
    );
  }
}
