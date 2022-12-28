import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_colors.dart';
import 'all_events_screen.dart';
import 'favourite_events_screen.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
                  child: Image.asset(
                    'assets/riviera_icon.png',
                    height: 300,
                    width: 400,
                  ),
                )),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: SvgPicture.asset('assets/search_icon.svg',
                    height: 20, width: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: SvgPicture.asset('assets/filter_icon.svg',
                    height: 20, width: 20),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "All Events",
                ),
                Tab(
                  text: "Favourites",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [AllEvents(), FavouriteEvents()],
          ),
        ));
  }
}
