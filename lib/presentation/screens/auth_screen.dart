import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/auth/auth_cubit.dart';
import 'package:riviera23/presentation/methods/custom_flushbar.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';

import '../../utils/app_colors.dart';

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
  var resetlinkSent = false;

  void signUpUser() async {
    BlocProvider.of<AuthCubit>(context).signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  void loginUser() {
    BlocProvider.of<AuthCubit>(context).loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    showConfirmPassword = false;
    resetlinkSent = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<AuthCubit>();
      cubit.checkAlreadySignedIn();
    });
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
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavScreen(null)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Reviving the Era...',
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  )
                ],
              );
            } else {
              return LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 90),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(45, 45, 45, 30),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7))),
                                      hintText: 'Email',
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7))),
                                      hintText: 'Password',
                                    ),
                                  )),
                              Visibility(
                                visible: !showConfirmPassword,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showForgotPasswordDialog(
                                          context, resetlinkSent);
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 5, 25, 5),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "Forgot Password?",
                                        style: GoogleFonts.sora(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showConfirmPassword,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 5),
                                    child: TextField(
                                      obscureText: true,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller: cpasswordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: const InputDecoration(
                                        label: Text(
                                          "Confirm Password",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                        hintText: 'Confirm Password',
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (emailController.text.trim().isNotEmpty &&
                                      passwordController.text
                                          .trim()
                                          .isNotEmpty) {
                                    if (showConfirmPassword) {
                                      if (cpasswordController.text
                                          .trim()
                                          .isNotEmpty) {
                                        if (passwordController.text.trim() ==
                                            cpasswordController.text.trim()) {
                                          signUpUser();
                                        } else {
                                          showCustomFlushbar("Error!", "Passwords don't match", context);
                                        }
                                      } else {
                                        showCustomFlushbar("Error!", "Please Enter email and password", context);
                                      }
                                    } else {
                                      loginUser();
                                    }
                                  } else {
                                    showCustomFlushbar("Error!", "Please Enter email and password", context);
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 5),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: const Color(0xff466FFF),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            showConfirmPassword
                                                ? const Text(
                                                    "Sign Up",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : const Text(
                                                    "Sign In",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
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
                                  BlocProvider.of<AuthCubit>(context)
                                      .signInWithGoogle(context);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 5),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/google_logo.svg"),
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
                              Platform.isAndroid
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<AuthCubit>(context)
                                            .signInWithApple(context);
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 5),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/apple_logo.svg"),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Text(
                                                    "Continue with Apple",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 50),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                  ),
                );
              });
            }
          },
        ),
      ),
    );
  }
}

showForgotPasswordDialog(BuildContext context, bool resetlinkSent) {
  final TextEditingController resetPassEmailController =
      TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState){
          return AlertDialog(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.highlightColor),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: resetlinkSent
                    ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),

                  child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.asset("assets/app_icon.png", height: 100, width: 100,),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                               Text(
                                "Reset Password Link Sent",
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: Text(
                                  "Please check your email for a link to reset your password. \nIf it doesn’t appear within a few minutes, check your spam folder.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.sora(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    )
                    : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                              child: Text(
                                "Reset Password",
                                style:
                                    GoogleFonts.sora(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Enter your email ID to reset your password", style: GoogleFonts.sora(color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                style: GoogleFonts.sora(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: resetPassEmailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabled: true,
                                    hintText: 'Email',
                                    hintStyle: GoogleFonts.sora(color: Colors.white, fontSize: 14),
                                    labelText: 'Email',
                                labelStyle: GoogleFonts.sora(color: Colors.white, fontSize: 14)),
                              ),
                            ),
                            SizedBox(
                              height: 0.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 65,
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (resetPassEmailController.text.isNotEmpty) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .sendResetPassowrdEmail(
                                            resetPassEmailController.text, context)
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          resetlinkSent = true;
                                        });
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.highlightColor,
                                  // fixedSize: Size(250, 50),
                                ),
                                child: Text(
                                  "Send",
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
              ),
            ),
          );},
        );
      });
}
