import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/utils/app_colors.dart';

class CustomBottomNavBarItem extends StatelessWidget {
  final String imgPath;
  final String label;
  final int index;
  final int selectedIndex;

  const CustomBottomNavBarItem({
    Key? key,
    required this.imgPath,
    required this.label,
    required this.index,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: index == 2
          ? MediaQuery.of(context).size.width * 0.30
          : MediaQuery.of(context).size.width * 0.175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: selectedIndex == index
                ? SvgPicture.asset(imgPath,
                    color: AppColors.highlightColor,
                    height: 20,
                    width: 20,
                    fit: BoxFit.scaleDown)
                : SvgPicture.asset(imgPath,
                    color: AppColors.secondaryColor,
                    height: 15,
                    width: 15,
                    fit: BoxFit.scaleDown),
          ),
          index == 2 ? const SizedBox(height: 0) : const SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: selectedIndex == index ? 12 : 10,
                  fontFamily: GoogleFonts.getFont('Sora').fontFamily)),
        ],
      ),
    );
  }
}
