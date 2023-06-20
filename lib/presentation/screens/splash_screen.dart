import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../constants/strings/asset_paths.dart';
import '../../constants/strings/strings.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/events/events_cubit.dart';
import '../../cubit/hashtag/hashtag_cubit.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<EventsCubit>();
      cubit.getAllEvents();
      final cubit2 = context.read<HashtagCubit>();
      cubit2.getAllHashtag();
      final cubit3 = context.read<AuthCubit>();
      cubit3.checkAlreadySignedIn();
    });

    leadtoGetStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: checkAuthState(),
    );
  }

  BlocConsumer<AuthCubit, AuthState> checkAuthState() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.of(context)
              .pushReplacementNamed("/bottomNavScreen", arguments: null);
        } else if (state is NotSignedInState) {
          setState(() {
            leadtoGetStarted = true;
          });
        }
      },
      builder: (context, state) {
        return buildBody(context);
      },
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildRivieraIcon(context),
            leadtoGetStarted
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: buildPageContent(context))
                : const Align(
                    alignment: Alignment.bottomCenter,
                    child: VitLogo(),
                  )
          ],
        );
  }

  Expanded buildRivieraIcon(BuildContext context) {
    return Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                    child: Image.asset(
                      AssetPaths.rivieraIcon,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

Padding buildPageContent(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.09),
    child: Column(
      children: [
        buildRivieraDesc(width),
        const SizedBox(
          height: 10,
        ),
        getStartedButton(width, context),
      ],
    ),
  );
}

SizedBox getStartedButton(double width, BuildContext context) {
  return SizedBox(
        height: 50,
        width: width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              "/authentication",
            );
          },
          child: Text(
            Strings.getStarted,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 15,
              fontFamily: GoogleFonts.sora.toString(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}

Padding buildRivieraDesc(double width) {
  return Padding(
        padding: EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: Strings.riviera,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 15,
              fontFamily: GoogleFonts.sora.toString(),
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: Strings.rivieraDesc,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 15,
                    fontFamily: GoogleFonts.sora.toString(),
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
        ),
      );
}

class VitLogo extends StatelessWidget {
  const VitLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.09),
      child: SvgPicture.asset(AssetPaths.vitLogo,
          color: AppColors.secondaryColor,
          height: 40,
          width: 50,
          fit: BoxFit.scaleDown),
    );
  }
}
