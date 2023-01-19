import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riviera23/presentation/methods/gdsc_dialog.dart';
import 'package:riviera23/presentation/screens/profile_screen.dart';
import 'package:riviera23/presentation/widgets/custom_bottomnavbar_item.dart';
import 'package:riviera23/utils/app_colors.dart';

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
  int tapCount  = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _fragments = <Widget>[
      HomeScreen(),
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
                      onTap: () {
                        if(selectedIndex == 2 ){
                          showCreatorDialog(context);
                        }
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
