import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riviera23/presentation/screens/announcement_history_screen.dart';
import 'package:riviera23/presentation/screens/merch_screen.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
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
  ScrollController? _controller;
  HomeScreen(this._controller);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GlobalKey _merch_guide = GlobalKey();
  GlobalKey _ongoing_guide = GlobalKey();

  @override
  void initState() {
    super.initState();

    checkForAppUpdate(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final user = AuthService(FirebaseAuth.instance).user;
      final cubit = context.read<EventsCubit>();
      cubit.getAllEvents();
      final cubit3 = context.read<FavouriteCubit>();
      cubit3.loadFavourites(user);
      displayShowcase(context, _merch_guide, _ongoing_guide);
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MerchScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: CustomShowcase(_merch_guide,"See all Merch", SvgPicture.asset('assets/merch_button.svg',
                    height: 22, width: 22)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AnnouncementHistoryScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: SvgPicture.asset('assets/notification_icon.svg',
                    height: 20, width: 20),
              ),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              controller: widget._controller,
              child: BlocBuilder<VenueCubit, VenueState>(
                  builder: (context, venueState) {
            if (venueState is VenueSuccess) {
              List<Venue> allVenues = venueState.venuesList;
              return Column(
                children: [
                  CarouselWithDotsPage(
                    allVenues: allVenues,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: FeaturedEvents(
                      allVenues: allVenues,
                    ),
                  ),
                  SizedBox(height: 0),
                  CustomShowcase(
                    _ongoing_guide,
                    "On Going Events will appear here.",
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                      child: OnGoingEvents(
                        allVenues: allVenues,
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          })),
        ),
      );
  }
}

class CustomShowcase extends StatelessWidget {
  GlobalKey _guide_key;
  String desc;
  Widget childWidget;
  CustomShowcase(this._guide_key,this.desc, this.childWidget);


  @override
  Widget build(BuildContext context) {
    return Showcase(
      key:_guide_key,
      description: desc,
      child: childWidget,
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
  var remote_version;
  if (Platform.isAndroid) {
    remote_version = prefs.getString('remote_app_version_android');
  } else {
    remote_version = prefs.getString('remote_app_version_ios');
  }

  print("home screen  " + remote_version);

  String? RemoteVersionApp = remote_version;
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
                    _launchURLBrowser(APP_STORE_URL, context);
                  },
                  child: Text(
                    btnLabel,
                  ),
                ),
              ],
            )
          : AlertDialog(
              backgroundColor: AppColors.cardBgColor,
              title: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              content: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
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
                  child: Text(btnLabel,
                      style: TextStyle(color: AppColors.highlightColor)),
                  onPressed: () {
                    _launchURLBrowser(PLAY_STORE_URL, context);
                  },
                ),
              ],
            );
    },
  );
}


displayShowcase(BuildContext context, GlobalKey<State<StatefulWidget>> key1, GlobalKey<State<StatefulWidget>> key2) async {


  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus = prefs.getBool("show_homescreen_showcase");

  if (showcaseVisibilityStatus == null) {
    prefs.setBool("show_homescreen_showcase", false);
    print("showcaseVisibilityStatus is null, showing homescreen showcase");
    ShowCaseWidget.of(context).startShowCase([key1, key2]);
  }else{
    print("showcaseVisibilityStatus is not null, not showing homescreen showcase");
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
