import 'package:flutter/material.dart';
import 'package:riviera23/constants/strings/asset_paths.dart';
import 'package:riviera23/presentation/screens/contacts_screen.dart';
import 'package:riviera23/presentation/screens/faq_screen.dart';

import '../../constants/strings/strings.dart';
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
          appBar: buildAppBar(),
          body: const TabBarView(
            children: [FAQScreen(), ContactScreen()],
          ),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0.0,
          title: Transform(
              // you can forcefully translate values left side using Transform
              transform: Matrix4.translationValues(10.0, 2.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  AssetPaths.rivieraIcon,
                  height: 40,
                  width: 90,
                  fit: BoxFit.contain,
                ),
              )),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [Tab(text: Strings.info), Tab(text: Strings.contactUs)],
          ),
        );
  }
}
