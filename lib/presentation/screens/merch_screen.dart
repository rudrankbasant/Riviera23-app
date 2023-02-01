import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/announcements/announcements_cubit.dart';
import '../methods/custom_flushbar.dart';

class MerchScreen extends StatefulWidget {
  @override
  State<MerchScreen> createState() => _MerchScreenState();
}

class _MerchScreenState extends State<MerchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Merchandise',
          style: GoogleFonts.sora(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.8),
          children: [
               GestureDetector(
                 onTap: (){
                   _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
                 },
                 child: Column(
              children: [
                  Image.asset("assets/merchandise/hoodie.png"),
                  SizedBox(height: 10),
                  Text(
                    "Hoodie",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 501",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
              ],
            ),
               ),
            GestureDetector(
              onTap: (){
                _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
              },
              child: Column(
                children: [
                  Image.asset("assets/merchandise/polo.png"),
                  SizedBox(height: 10),
                  Text(
                    "Polo",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 350",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
              },
              child: Column(
                children: [
                  Image.asset("assets/merchandise/tee.png"),
                  SizedBox(height: 10),
                  Text(
                    "Round Neck Tee",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 250",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
              },
              child: Column(
                children: [
                  Container(
                    height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset("assets/merchandise/rncnh.png",
                          fit: BoxFit.contain,),
                      ),),
                  SizedBox(height: 10),
                  Text(
                    "Combo 1",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 991",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
              },
              child: Column(
                children: [
                  Container(
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset("assets/merchandise/rncn.png",
                        fit: BoxFit.contain,),
                    ),),
                  SizedBox(height: 10),
                  Text(
                    "Combo 2",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 540",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
              },
              child: Column(
                children: [
                  Container(
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset("assets/merchandise/cnh.png",
                        fit: BoxFit.contain,),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Combo 3",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 675",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                _launchURLBrowser("https://vtop.vit.ac.in/vtop", context);
              },
              child: Column(
                children: [
                  Container(
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset("assets/merchandise/rnh.png",
                        fit: BoxFit.contain,),
                    ),),
                  SizedBox(height: 10),
                  Text(
                    "Combo 4",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  Text(
                    "Rs. 765",
                    style: GoogleFonts.sora(
                        color: AppColors.highlightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )
                ],
              ),
            ),

            ]
          ,
        ),
      ),
    );
  }
}

void _launchURL(_url, BuildContext context) async {
  final Uri _uri = Uri.parse(_url);
  try {
    await canLaunchUrl(_uri)
        ? await launchUrl(_uri)
        : throw 'Could not launch $_uri';
  } catch (e) {
    print(e.toString());
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}

void _launchURLBrowser(_url, BuildContext context) async {
  final Uri _uri = Uri.parse(_url);
  try {
    await canLaunchUrl(_uri)
        ? await launchUrl(_uri, mode: LaunchMode.externalApplication)
        : throw 'Could not launch $_uri';
  } catch (e) {
    print(e.toString());
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}
