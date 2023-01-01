import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(10.0, 2.0, 0.0),
            child: Container(
              child: Image.asset(
                'assets/riviera_icon.png',
                height: 40,
                width: 90,
                fit: BoxFit.contain,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: 75.0,
                      height: 75.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/en/6/66/Matthew_Perry_as_Chandler_Bing.png")))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tame Impala",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily:
                                  GoogleFonts.getFont("Sora").fontFamily)),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("21BCH1234",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily:
                                    GoogleFonts.getFont("Sora").fontFamily)),
                      ),
                    ],
                  ),
                ],
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
            const ProfileInfo(
                imgPath: "assets/icons/qr_code.svg",
                infoText: "tameimpala@gmail.com",
                isButton: false),
            const ProfileInfo(
                imgPath: "assets/icons/qr_code.svg",
                infoText: "8756391101",
                isButton: false),
            const ProfileInfo(
                imgPath: "assets/icons/qr_code.svg",
                infoText: "Favorite Events",
                isButton: true),
             ProfileInfo(
                imgPath: "assets/icons/qr_code.svg",
                infoText: "Sign Out",
                isButton: true,
             ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/en/6/66/Matthew_Perry_as_Chandler_Bing.png")))),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text('deletethis',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: GoogleFonts.getFont("Sora").fontFamily)),
                   ElevatedButton(
                    onPressed: () {

                    },
                    child: SvgPicture.asset('assets/right_arrow.svg',
                        height: 20, width: 20),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
