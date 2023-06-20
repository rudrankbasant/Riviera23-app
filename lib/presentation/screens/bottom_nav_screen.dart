import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riviera23/constants/strings/asset_paths.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
import 'package:riviera23/presentation/methods/gdsc_dialog.dart';
import 'package:riviera23/presentation/screens/profile_screen.dart';
import 'package:riviera23/presentation/widgets/bottomnavbar_item.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../constants/strings/strings.dart';
import 'events_screen.dart';
import 'hashtags_screen.dart';
import 'home_screen.dart';
import 'info_screen.dart';

class BottomNavScreen extends StatefulWidget {
  int? eventScreenIndex;

  BottomNavScreen(this.eventScreenIndex, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<BottomNavScreen> {
  int selectedIndex = 0;
  int tapCount = 0;
  late Timer _timer;



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    final List<Widget> fragments = <Widget>[
      ShowCaseWidget(
          scrollDuration: const Duration(milliseconds: 500),
          onStart: (index, key) {
            if (index == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.jumpTo(300);
              });
            }
          },
          builder: Builder(builder: (context) => HomeScreen(controller))),
      EventsScreen(widget.eventScreenIndex ?? 0),
      const HashtagsScreen(),
      const InfoScreen(),
      const ProfileScreen()
    ];

    if (widget.eventScreenIndex != null) {
      setState(() {
        selectedIndex = 1;
      });
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.primaryColor,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: fragments[selectedIndex],
            ),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.075,
              child: Row(
                children: <Widget>[
                buildSideButton(0, AssetPaths.homeIcon, Strings.home),
                  buildSideButton(1, AssetPaths.eventsIcon, Strings.events),
                  buildMiddleButton(),
                  buildSideButton(3, AssetPaths.infoIcon, Strings.info),
                  buildSideButton(4, AssetPaths.profileIcon, Strings.profile),
                ],
              ),
            )));
  }



  InkWell buildSideButton(int index, String assetPath, String label) {
    return InkWell(
                  radius: 10,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: CustomBottomNavBarItem(
                    imgPath: assetPath,
                    label: label,
                    index: index,
                    selectedIndex: selectedIndex,
                  ),
                );
  }

  Expanded buildMiddleButton() {
    return Expanded(
      child: InkWell(
        radius: 10,
        onTapDown: (_) {
          _startOperation();
        },
        onTapUp: (_) {
          _timer.cancel();
        },
        onTap: () {
          setState(() {
            selectedIndex = 2;
          });
        },
        child: Column(
          children: [
            CustomBottomNavBarItem(
                label: Strings.hashtags,
                index: 2,
                selectedIndex: selectedIndex,
                imgPath: AssetPaths.rivieraIcon),
          ],
        ),
      ),
    );
  }

  Future<bool> getGSDCBoolean() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showGDSC = prefs.getBool(SharedPrefKeys.idRemoteShowGdsc);
    if (showGDSC != null) {
      return showGDSC;
    }
    return false;
  }

  Future<void> _startOperation() async {
    var showGDSC = await getGSDCBoolean();
    if (showGDSC) {
      _timer = Timer(const Duration(milliseconds: 4000), () {
        showCreatorDialog(context);
      });
    }
  }
}
