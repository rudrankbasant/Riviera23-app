import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfo extends StatelessWidget {
  final String imgPath;
  final String infoText;
  final bool isButton;
  final Function()? onPressed;

  const ProfileInfo({
    Key? key,
    required this.imgPath,
    required this.infoText,
    required this.isButton,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(imgPath)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Flexible(
                    child: Text(infoText,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: GoogleFonts.getFont("Sora").fontFamily)),
                  ),
                ],
              )
          ),
          isButton
              ? GestureDetector(
                  onTap: () {
                    onPressed!();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SvgPicture.asset('assets/right_arrow_icon.svg',
                        height: 20, width: 20),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
