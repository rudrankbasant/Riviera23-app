import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfo extends StatelessWidget {
  final String imgPath;
  final String infoText;
  final bool isButton;

  const ProfileInfo({
    Key? key,
    required this.imgPath,
    required this.infoText,
    required this.isButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Text(infoText,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: GoogleFonts.getFont("Sora").fontFamily)),
          isButton
              ? ElevatedButton(
                  onPressed: () {},
                  child: SvgPicture.asset('assets/right_arrow.svg',
                      height: 20, width: 20),
                )
              : Container(),
        ],
      ),
    );
  }
}
