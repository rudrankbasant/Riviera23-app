import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';

class HashtagsScreen extends StatefulWidget {
  @override
  State<HashtagsScreen> createState() => _HashtagsScreenState();
}

class _HashtagsScreenState extends State<HashtagsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.asset("assets/riviera_icon.png"),
          Container(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '#riviera23',
                style: TextStyle(
                    color: AppColors.highlightColor,
                    fontFamily: GoogleFonts.sora.toString()),
                children: <TextSpan>[
                  TextSpan(
                      text: ' photowall',
                      style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontFamily: GoogleFonts.sora.toString())),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Use ',
                style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontFamily: GoogleFonts.sora.toString()),
                children: <TextSpan>[
                  TextSpan(
                      text: '#riviera23',
                      style: TextStyle(
                          color: AppColors.highlightColor,
                          fontFamily: GoogleFonts.sora.toString())),
                  TextSpan(
                      text:
                          ' on your instagram to get featured on this timeline.',
                      style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontFamily: GoogleFonts.sora.toString())),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
