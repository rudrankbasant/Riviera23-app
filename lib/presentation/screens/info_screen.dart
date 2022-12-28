import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riviera23/presentation/screens/contacts_screen.dart';
import 'package:riviera23/presentation/screens/faq_screen.dart';

import '../../utils/app_colors.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                child: Container(
                  child: SvgPicture.asset(
                    'assets/riviera_icon.svg',
                    height: 20,
                    width: 60,
                  ),
                )),
            bottom: const TabBar(
              tabs: [Tab(text: "FAQ"), Tab(text: "Contact Us")],
            ),
          ),
          body: TabBarView(
            children: [FAQScreen(), ContactScreen()],
          ),
        ));
  }
}
