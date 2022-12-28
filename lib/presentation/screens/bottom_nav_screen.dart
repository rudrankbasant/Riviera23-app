import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riviera23/presentation/screens/profile_screen.dart';
import 'package:riviera23/presentation/widgets/custom_bottomnavbar_item.dart';
import 'package:riviera23/utils/app_colors.dart';

import 'events_screen.dart';
import 'hashtags_screen.dart';
import 'home_screen.dart';
import 'info_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<BottomNavScreen> {
  int selectedIndex = 0;
  final List<Widget> _fragments = <Widget>[
    HomeScreen(),
    EventsScreen(),
    HashtagsScreen(),
    InfoScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 7.5, 2, 2),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
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
                    GestureDetector(
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
                      child: GestureDetector(
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
                    GestureDetector(
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
                    GestureDetector(
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
              ),
            )));
  }
}
