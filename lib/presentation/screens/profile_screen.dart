import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/profile_info.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
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
          const ProfileInfo(
              imgPath: "assets/icons/qr_code.svg",
              infoText: "Sign Out",
              isButton: true)
        ],
      ),
    );
  }
}
