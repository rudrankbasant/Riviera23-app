import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riviera23/presentation/methods/gdsc_dialog.dart';
import 'package:riviera23/presentation/screens/profile_screen.dart';
import 'package:riviera23/presentation/widgets/custom_bottomnavbar_item.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'events_screen.dart';
import 'hashtags_screen.dart';
import 'home_screen.dart';
import 'info_screen.dart';

class BottomNavScreen extends StatefulWidget {
  int? eventScreenIndex;

  BottomNavScreen(this.eventScreenIndex);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<BottomNavScreen> {
  int selectedIndex = 0;
  int tapCount = 0;
  late Timer _timer;


  Future<bool> getGSDCBoolean() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showGDSC = prefs.getBool("remote_show_gdsc");
    if(showGDSC != null){
      return showGDSC;
    }
    return false;
  }

  Future<void> _startOperation() async {
    var showGDSC = await getGSDCBoolean();
    print("showGDSC: $showGDSC");
    if(showGDSC){
      _timer = Timer(const Duration(milliseconds: 4000), () {
        showCreatorDialog(context);
      });
    }

  }



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
    final _controller = ScrollController();

    final List<Widget> _fragments = <Widget>[
      ShowCaseWidget(
          scrollDuration: 	Duration(milliseconds: 500),
          onStart: (index, key) {
            if(index == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller.jumpTo(300);
              });
            }
          },
    builder: Builder(
    builder : (context)=>HomeScreen(_controller))),
      EventsScreen(widget.eventScreenIndex ?? 0),
      HashtagsScreen(),
      InfoScreen(),
      ProfileScreen()
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
              child: _fragments[selectedIndex],
            ),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.075,
              child: Row(
                children: <Widget>[
                  InkWell(
                    radius: 10,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: CustomBottomNavBarItem(
                      imgPath: "assets/home_icon.svg",
                      label: "Home",
                      index: 0,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                  InkWell(
                    radius: 10,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: CustomBottomNavBarItem(
                      imgPath: "assets/events_icon.svg",
                      label: "Events",
                      index: 1,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                  Expanded(
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
                            label: "Hashtags",
                            index: 2,
                            selectedIndex: selectedIndex,
                            imgPath: 'assets/riviera_icon.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    radius: 10,
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                    child: CustomBottomNavBarItem(
                      imgPath: "assets/info_icon.svg",
                      label: "Info",
                      index: 3,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                  InkWell(
                    radius: 10,
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                      });
                    },
                    child: CustomBottomNavBarItem(
                      imgPath: "assets/profile_icon.svg",
                      label: "Profile",
                      index: 4,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                ],
              ),
            )));
  }
}
