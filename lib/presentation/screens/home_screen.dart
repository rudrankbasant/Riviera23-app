import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riviera23/constants/strings/asset_paths.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
import 'package:riviera23/cubit/auth/auth_cubit.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../constants/strings/strings.dart';
import '../../cubit/events/events_cubit.dart';
import '../../cubit/favourites/favourite_cubit.dart';
import '../../cubit/venue/venue_cubit.dart';
import '../../data/models/venue_model.dart';
import '../methods/launch_url.dart';
import '../widgets/dotted_carousel.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/ongoing_carousel.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController? _controller;

  const HomeScreen(this._controller, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _merch_guide = GlobalKey();
  final GlobalKey _ongoing_guide = GlobalKey();

  @override
  void initState() {
    super.initState();

    checkForAppUpdate(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final user = AuthCubit().user;
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
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  Container buildBody(BuildContext context) {
    return Container(
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: FeaturedEvents(
                      allVenues: allVenues,
                    ),
                  ),
                  const SizedBox(height: 0),
                  CustomShowcase(
                    _ongoing_guide,
                    Strings.placeholderTextEventOngoing,
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
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/merch');
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: CustomShowcase(
                _merch_guide,
                Strings.seeAllMerch,
                SvgPicture.asset(AssetPaths.merchIcon,
                    height: 22, width: 22)),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/announcements');
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: SvgPicture.asset(AssetPaths.notificationIcon,
                height: 20, width: 20),
          ),
        ),
      ],
    );
  }
}

class CustomShowcase extends StatelessWidget {
  final GlobalKey _guide_key;
  String desc;
  Widget childWidget;

  CustomShowcase(this._guide_key, this.desc, this.childWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: _guide_key,
      description: desc,
      child: childWidget,
    );
  }
}

const APP_STORE_URL = Strings.appLinkApple;

const PLAY_STORE_URL = Strings.appLinkGoogle;

void checkForAppUpdate(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? appStarted = prefs.getBool(SharedPrefKeys.appStarted);
  if (appStarted == true) {
    _notifyForAppUpdate(context);
    prefs.setBool(SharedPrefKeys.appStarted, false);
  }
}

void _notifyForAppUpdate(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String version = packageInfo.version;

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? remoteVersion;
  if (Platform.isAndroid) {
    remoteVersion = prefs.getString(SharedPrefKeys.idRemoteAppVersionAndroid);
  } else {
    remoteVersion = prefs.getString(SharedPrefKeys.idRemoteAppVersionIos);
  }

  String? RemoteVersionApp = remoteVersion;
  if (RemoteVersionApp != null && RemoteVersionApp != "") {
    double localVersion = double.parse(version.trim().replaceAll(".", ""));
    double latestVersion =
        double.parse(RemoteVersionApp.trim().replaceAll(".", ""));

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
      String title = Strings.updateTitle;
      String message = Strings.updateDesc;
      String btnLabelCancel = Strings.later;
      String btnLabel = Strings.updateNow;
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
                    launchURL(APP_STORE_URL, context, true);
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
                style: const TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    btnLabelCancel,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(btnLabel,
                      style: TextStyle(color: AppColors.highlightColor)),
                  onPressed: () {
                    launchURL(PLAY_STORE_URL, context, true);
                  },
                ),
              ],
            );
    },
  );
}

displayShowcase(BuildContext context, GlobalKey<State<StatefulWidget>> key1,
    GlobalKey<State<StatefulWidget>> key2) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus =
      prefs.getBool(SharedPrefKeys.homeScreenGuide);

  if (showcaseVisibilityStatus == null) {
    prefs.setBool(SharedPrefKeys.homeScreenGuide, false);

    ShowCaseWidget.of(context).startShowCase([key1, key2]);
  }
}
