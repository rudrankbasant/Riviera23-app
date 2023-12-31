import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/utils/app_colors.dart';

class BottomNavBarItem extends StatelessWidget {
  final String imgPath;
  final String label;
  final int index;
  final int selectedIndex;

  const BottomNavBarItem({
    Key? key,
    required this.imgPath,
    required this.label,
    required this.index,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: index == 2
          ? MediaQuery.of(context).size.width * 0.30
          : MediaQuery.of(context).size.width * 0.175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          index == 2
              ? (selectedIndex == index
                  ? const SizedBox(height: 2)
                  : const SizedBox(
                      height: 3,
                    ))
              : const SizedBox(height: 0),
          buildIcon(),
          index == 2 ? const SizedBox(height: 0) : const SizedBox(height: 5),
          index != 2
              ? Text(label,
                  style: TextStyle(
                      color: selectedIndex == index
                          ? AppColors.highlightColor
                          : Colors.white,
                      fontSize:
                          index == 2 ? 10 : (selectedIndex == index ? 12 : 10),
                      fontFamily: index == 2
                          ? GoogleFonts.getFont('Bad Script').toString()
                          : GoogleFonts.getFont('Sora').fontFamily))
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }

  Container buildIcon() {
    return Container(
      child: index == 2
          ? (selectedIndex == index
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Image.asset(imgPath,
                      color: AppColors.highlightColor,
                      height: 50,
                      width: 120,
                      fit: BoxFit.scaleDown))
              : Padding(
                  padding: const EdgeInsets.fromLTRB(5, 7, 0, 0),
                  child: Image.asset(imgPath,
                      color: AppColors.secondaryColor,
                      height: 40,
                      width: 90,
                      fit: BoxFit.scaleDown),
                ))
          : (selectedIndex == index
              ? SvgPicture.asset(imgPath,
                  color: AppColors.highlightColor,
                  height: 20,
                  width: 20,
                  fit: BoxFit.scaleDown)
              : SvgPicture.asset(imgPath,
                  color: AppColors.secondaryColor,
                  height: 15,
                  width: 15,
                  fit: BoxFit.scaleDown)),
    );
  }
}
