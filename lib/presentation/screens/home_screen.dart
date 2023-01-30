import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riviera23/cubit/featured/featured_cubit.dart';
import 'package:riviera23/cubit/proshows/proshows_cubit.dart';
import 'package:riviera23/presentation/screens/announcement_history_screen.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/events/events_cubit.dart';
import '../../cubit/favourites/favourite_cubit.dart';
import '../../cubit/venue/venue_cubit.dart';
import '../../data/models/venue_model.dart';
import '../../service/auth.dart';
import '../methods/custom_flushbar.dart';
import '../widgets/carousel_with_dots_page.dart';
import '../widgets/featured_events.dart';
import '../widgets/on_going_events.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    checkForAppUpdate(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubitProShows = context.read<ProShowsCubit>();
      cubitProShows.getAllProShows();

      final cubitFeatured = context.read<FeaturedCubit>();
      cubitFeatured.getAllFeatured();

      final user = AuthService(FirebaseAuth.instance).user;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final cubit = context.read<EventsCubit>();
        cubit.getAllEvents();
        final cubit2 = context.read<FavouriteCubit>();
        cubit2.loadFavourites(user);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(10.0, 2.0, 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/riviera_icon.png',
                  height: 40,
                  width: 90,
                  fit: BoxFit.contain,
                ),
              ),
            )),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AnnouncementHistoryScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: SvgPicture.asset('assets/notification_icon.svg',
                  height: 20, width: 20),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child:
              BlocBuilder<VenueCubit, VenueState>(
                  builder: (context, venueState) {
            if (venueState is VenueSuccess) {
              List<Venue> allVenues = venueState.venuesList;
              return Column(
                children: [
                  CarouselWithDotsPage(
                    allVenues: allVenues,
                  ),
                  SizedBox(height: 30),
                  FeaturedEvents(
                    allVenues: allVenues,
                  ),
                  SizedBox(height: 0),
                  OnGoingEvents(
                    allVenues: allVenues,
                  )
                ],
              );
            } else {
              return Container();
            }
          })),
        ),
      ),
    );
  }
}

const APP_STORE_URL = 'https://apps.apple.com/in/app/riviera-23/id1665459606';
const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=in.ac.vit.riviera23';

void checkForAppUpdate(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? appStarted = prefs.getBool('appStarted');
  if (appStarted == true) {
    _notifyForAppUpdate(context);
    prefs.setBool('appStarted', false);
  }
}

void _notifyForAppUpdate(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  print("App Name: $appName");
  print("Package Name: $packageName");
  print("Version: $version");
  print("Build Number: $buildNumber");

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? RemoteVersionApp = prefs.getString('remote_app_version');
  if (RemoteVersionApp != null && RemoteVersionApp != "") {
    double localVersion = double.parse(version.trim().replaceAll(".", ""));
    double latestVersion =
        double.parse(RemoteVersionApp.trim().replaceAll(".", ""));

    print("Local Version: $localVersion");
    print("Latest Version: $latestVersion");
    if (latestVersion > localVersion) {
      _showVersionDialog(context);
    }
  }
}

_showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "Update Available";
      String message =
          "A new version of the app is available. Please update to the latest version.";
      String btnLabelCancel = "Later";
      String btnLabel = "Update Now";
      return Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    btnLabelCancel,
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    _launchURL(APP_STORE_URL, context);
                  },
                  child: Text(
                    btnLabel,
                  ),
                ),
              ],
            )
          : AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    btnLabelCancel,
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(btnLabel, style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    _launchURL(PLAY_STORE_URL, context);
                  },
                ),
              ],
            );
    },
  );
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
