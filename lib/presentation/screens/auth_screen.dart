import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/auth/auth_cubit.dart';
import 'package:riviera23/presentation/methods/custom_flushbar.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';
import '../widgets/apple_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/google_button.dart';
import '../widgets/submit_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  bool showConfirmPassword = false;
  bool resetLinkSent = false;

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
    resetLinkSent = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<AuthCubit>();
      cubit.checkAlreadySignedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildBody(context),
    );
  }

  Container buildBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPaths.authBg),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.of(context)
                .pushReplacementNamed("/bottomNavScreen", arguments: null);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return buildAuthLoading();
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
                        const SizedBox(height: 90),
                        buildAuthFields(context),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        buildAuthOptions(),
                      ],
                    ),
                  ),
                ),
              );
            });
          }
        },
      ),
    );
  }

  Column buildAuthFields(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(45, 45, 45, 30),
          child: Image.asset(AssetPaths.rivieraIcon),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(Strings.titleAuth,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                fontFamily: GoogleFonts.sora.toString(),
              )),
        ),
        AuthFormField(
          textController: emailController,
          textInputType: TextInputType.emailAddress,
          label: Strings.emailAuth,
          obscureText: false,
        ),
        AuthFormField(
          textController: passwordController,
          textInputType: TextInputType.visiblePassword,
          label: Strings.passwordAuth,
          obscureText: true,
        ),
        showForgotPassword(context),
        Visibility(
          visible: showConfirmPassword,
          child: AuthFormField(
            textController: cpasswordController,
            textInputType: TextInputType.visiblePassword,
            label: Strings.confirmPasswordAuth,
            obscureText: true,
          ),
        ),
        GestureDetector(
          onTap: () {
            validateAndSubmit();
          },
          child: SubmitButton(showConfirmPassword: showConfirmPassword),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Row(children: <Widget>[
            Expanded(
                child: Divider(
              color: Colors.grey,
            )),
            Text(Strings.or,
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
        const GoogleSignIn(),
        Platform.isAndroid
            ? Container()
            : const AppleSignIn(),
      ],
    );
  }

  Visibility showForgotPassword(BuildContext context) {
    return Visibility(
        visible: !showConfirmPassword,
        child: GestureDetector(
          onTap: () {
            setState(() {
              showForgotPasswordDialog(context, resetLinkSent);
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 25, 5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                Strings.forgotPasswordAuth,
                style: GoogleFonts.sora(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10),
              ),
            ),
          ),
        ),
      );
  }

  GestureDetector buildAuthOptions() {
    return GestureDetector(
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
                          Strings.loginGuideAuth,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const Text(
                          Strings.signupGuideAuth,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
            ),
          )),
    );
  }

  Column buildAuthLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(
          height: 40,
        ),
        Text(
          Strings.loadingAuth,
          style: GoogleFonts.sora(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        )
      ],
    );
  }

  void validateAndSubmit() {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      if (showConfirmPassword) {
        if (cpasswordController.text.trim().isNotEmpty) {
          if (passwordController.text.trim() ==
              cpasswordController.text.trim()) {
            signUpUser();
          } else {
            showCustomFlushbar(Strings.generalErrorTitle,
                Strings.passwordsDontMatch, context);
          }
        } else {
          showCustomFlushbar(Strings.generalErrorTitle,
              Strings.emailPasswordAuth, context);
        }
      } else {
        loginUser();
      }
    } else {
      showCustomFlushbar(Strings.generalErrorTitle,
          Strings.emailPasswordAuth, context);
    }
  }
}

showForgotPasswordDialog(BuildContext context, bool resetlinkSent) {
  final TextEditingController resetPassEmailController =
      TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.highlightColor),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: resetlinkSent
                      ? buildSentDialog()
                      : buildResetDialog(resetPassEmailController, context, setState, resetlinkSent),
                ),
              ),
            );
          },
        );
      });
}

BackdropFilter buildResetDialog(TextEditingController resetPassEmailController, BuildContext context, StateSetter setState, bool resetlinkSent) {
  return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                              child: Text(
                                Strings.resetPasswordAuth,
                                style: GoogleFonts.sora(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Strings.resetDescAuth,
                                style: GoogleFonts.sora(
                                    color: Colors.white, fontSize: 14),
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
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabled: true,
                                    hintText: Strings.emailAuth,
                                    hintStyle: GoogleFonts.sora(
                                        color: Colors.white, fontSize: 14),
                                    labelText: Strings.emailAuth,
                                    labelStyle: GoogleFonts.sora(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(
                              height: 0.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 65,
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (resetPassEmailController
                                      .text.isNotEmpty) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .sendResetPasswordEmail(
                                            resetPassEmailController.text,
                                            context)
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
                                  backgroundColor: AppColors.highlightColor,
                                  // fixedSize: Size(250, 50),
                                ),
                                child: const Text(
                                  Strings.send,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
}

BackdropFilter buildSentDialog() {
  return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.asset(
                                  AssetPaths.appIcon,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                Strings.resetLinkSentAuth,
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: Text(
                                  Strings.resetLinkDescAuth,
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
                      );
}
