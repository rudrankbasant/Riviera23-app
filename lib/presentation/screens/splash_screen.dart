import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/screens/auth_screen.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../service/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool leadtoGetStarted = false;

  @override
  void initState() {
    super.initState();
    checkifUserLoggedIn();
    leadtoGetStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Center(
            child: Container(
              child: Image.asset(
                'assets/riviera_icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          leadtoGetStarted
              ? Expanded(child: getStarted(context))
              : Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: const VitLogo(),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Future<void> checkifUserLoggedIn() async {
    bool isLoggedIn =
        await AuthService(FirebaseAuth.instance).checkAlreadySignedIn();

    if (isLoggedIn) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavScreen(null))));
    } else {
      Timer(
          Duration(seconds: 3),
          () => setState(() {
                leadtoGetStarted = true;
              }));
    }
  }
}

Column getStarted(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Riviera23',
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 15,
              fontFamily: GoogleFonts.sora.toString(),
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                  text:
                      ' is the Annual International Sports and Cultural Carnival of the Vellore Institute of Technology.',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 15,
                    fontFamily: GoogleFonts.sora.toString(),
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 50,
        width: width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthScreen(),
              ),
            );
          },
          child: Text(
            'GET STARTED',
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 15,
              fontFamily: GoogleFonts.sora.toString(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

class VitLogo extends StatelessWidget {
  const VitLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/vit_logo.svg",
        color: AppColors.secondaryColor,
        height: 40,
        width: 50,
        fit: BoxFit.scaleDown);
  }
}