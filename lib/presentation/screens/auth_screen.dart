import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';
import 'package:riviera23/service/auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  var showConfirmPassword = false;

  void signUpUser() async {
    AuthService(FirebaseAuth.instance).signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  void loginUser() {
    AuthService(FirebaseAuth.instance)
        .loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    )
        .then((value) {
      if (value != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavScreen(null)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    showConfirmPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45, 45, 45, 30),
                    child: Image.asset("assets/riviera_icon.png"),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("WELCOME TO RIVIERA'23",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          fontFamily: GoogleFonts.sora.toString(),
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text(
                            "Email",
                            style: TextStyle(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                          hintText: 'Email',
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          label: Text(
                            "Password",
                            style: TextStyle(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                          hintText: 'Password',
                        ),
                      )),
                  Visibility(
                    visible: showConfirmPassword,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: TextField(
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          controller: cpasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            label: Text(
                              "Confirm Password",
                              style: TextStyle(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            hintText: 'Confirm Password',
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        if (showConfirmPassword) {
                          if (cpasswordController.text.trim().isNotEmpty) {
                            if (passwordController.text.trim() ==
                                cpasswordController.text.trim()) {
                              signUpUser();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter confirm password"),
                              ),
                            );
                          }
                        } else {
                          loginUser();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter email and password"),
                          ),
                        );
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: const Color(0xff466FFF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                showConfirmPassword
                                    ? const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : const Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Row(children: const <Widget>[
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                      )),
                      Text("OR",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          )),
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                      )),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthService(FirebaseAuth.instance)
                          .signInWithGoogle(context)
                          .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavScreen(null))));
                    },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/google_logo.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Continue with Google",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  Platform.isAndroid ? Container() :GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/apple_logo.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Continue with Apple",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  showConfirmPassword = !showConfirmPassword;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showConfirmPassword
                              ? const Text(
                                  "Already have an account? Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : const Text(
                                  "Don't have an account? Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
