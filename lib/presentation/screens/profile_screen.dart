import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/screens/auth_screen.dart';
import 'package:riviera23/presentation/screens/events_screen.dart';
import 'package:riviera23/service/auth.dart';

import '../../utils/app_colors.dart';
import '../widgets/profile_info.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService(FirebaseAuth.instance).user;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        /*systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        )*/
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(10.0, 2.0, 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/riviera_icon.png',
                  height: 40,
                  width: 90,
                  fit: BoxFit.contain,
                ),
              ),
            )),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Visibility(
              visible: user.displayName != null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: CachedNetworkImage(
                        width: 75.0,
                        height: 75.0,
                        imageUrl: user.photoURL.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 250.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                        )),
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: AppColors.secondaryColor,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                            "assets/app_icon.png"),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName.toString(),
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily:
                                      GoogleFonts.getFont("Sora").fontFamily)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text("Action Section",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontFamily: GoogleFonts.getFont("Sora").fontFamily)),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            ProfileInfo(
                imgPath: "assets/email_icon.svg",
                infoText: user.email.toString(),
                isButton: false),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventsScreen(1)));
              },
              child: ProfileInfo(
                imgPath: "assets/favourite_icon.svg",
                infoText: "Favorite Events",
                isButton: true,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventsScreen(1)));
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthService(FirebaseAuth.instance)
                    .signOut(context)
                    .then((isSuccess) {
                  if (isSuccess) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset("assets/sign_out_icon.svg"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text('Sign Out',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily:
                                    GoogleFonts.getFont("Sora").fontFamily)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SvgPicture.asset('assets/right_arrow_icon.svg',
                          height: 20, width: 20),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
