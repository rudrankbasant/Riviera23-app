import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/screens/auth_screen.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/events/events_cubit.dart';
import '../../cubit/favourites/favourite_cubit.dart';
import '../../cubit/hashtag/hashtag_cubit.dart';
import '../../data/models/data_version.dart';
import '../../firebase_options.dart';
import '../../service/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool leadtoGetStarted = false;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }


  @override
  Future<void> initState() async {
    super.initState();

    initilizeApp();
    setSystemUiOverlayStyle();
    checkifUserLoggedIn();
    fetchAppData();
    leadtoGetStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                      child: Image.asset(
                        'assets/riviera_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          leadtoGetStarted
              ? Align(
                  alignment: Alignment.bottomCenter, child: getStarted(context))
              : const Align(
                  alignment: Alignment.bottomCenter,
                  child: VitLogo(),
                )
        ],
      ),
    );
  }

  Future<void> checkifUserLoggedIn() async {
    bool isLoggedIn =
        await AuthService(FirebaseAuth.instance).checkAlreadySignedIn();

    if (isLoggedIn) {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavScreen(null))));
    } else {
      Timer(
          Duration(seconds: 2),
          () => setState(() {
                leadtoGetStarted = true;
              }));
    }
  }

  void fetchAppData() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<EventsCubit>();
      cubit.getAllEvents();
      final cubit2 = context.read<HashtagCubit>();
      cubit2.getAllHashtag();
    });
  }

  void setSystemUiOverlayStyle() {
    //Setting SysemUIOverlay
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: AppColors.primaryColor,
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light
    ));

    //Setting SystmeUIMode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);
  }

  Future<void> initilizeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


    print(" main dart Before");
    //Check for data updates
    await getDataUpdate();
    await setAppStarted();
    print(" main dart After");

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'riviera_notif_channel', // id
        'Riviera 2023', // title
        // description
        importance: Importance.max,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,

                  icon: "",
                  // other properties...
                ),
              ));
        }
      });
    }

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  getDataUpdate() async {

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(const {
      "android_version": "1.0.10",
      "base_url": "https://riviera.fly.dev",
      "ios_version": "1.0.10",
      "show_gdsc": false,
    });

    await remoteConfig.fetchAndActivate();
    final androidVersion = remoteConfig.getString("android_version");
    final iosVersion = remoteConfig.getString("ios_version");
    var baseUrl = remoteConfig.getString("base_url");
    final showGdsc = remoteConfig.getBool("show_gdsc");

    print("main dart: $baseUrl");
    print("android version: $androidVersion");






    //Check for data updates
    DataVersion RemoteVersions = await getRemoteVersion();
    print("Remote Version: $RemoteVersions");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //App Version is String
    prefs.setString("remote_app_version_android", androidVersion);
    prefs.setString("remote_app_version_ios", iosVersion);
    prefs.setString("remote_base_url", baseUrl);
    prefs.setBool("remote_show_gdsc", showGdsc);

    //All other Data Versions are int (DONT CACHE FAVOURITES EVEN THOUGH TAKING VERSION NUMBER)
    prefs.setInt(
        "remote_announcement", RemoteVersions.announcement_version_number);
    prefs.setInt("remote_contacts", RemoteVersions.contacts_version_number);
    prefs.setInt("remote_faq", RemoteVersions.faq_version_number);
    prefs.setInt("remote_fav", RemoteVersions.favorites_version_number);
    prefs.setInt("remote_places", RemoteVersions.places_version_number);
    prefs.setInt("remote_sponsors", RemoteVersions.sponsors_version_number);
    prefs.setInt("remote_team", RemoteVersions.team_version_number);
  }

  Future<DataVersion> getRemoteVersion() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('dataversion')
          .doc('Si44DbMWkgcwGVcKcW54')
          .get();

      Map<String, dynamic> data = timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint("this is version data" + data.toString());
      DataVersion dataVersion = DataVersion.fromMap(data);

      return dataVersion;
    } catch (e) {
      print(e.toString());
      return DataVersion(
          app_version_number: "",
          announcement_version_number: -1,
          contacts_version_number: -1,
          faq_version_number: -1,
          favorites_version_number: -1,
          places_version_number: -1,
          sponsors_version_number: -1,
          team_version_number: -1);
    }
  }

  Future<void> setAppStarted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('appStarted', true);
  }
}

Padding getStarted(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.09),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Riviera',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 15,
                fontFamily: GoogleFonts.sora.toString(),
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                    text:
                        ' is the Annual International Sports and Cultural Carnival of the Vellore Institute of Technology.',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 15,
                      fontFamily: GoogleFonts.sora.toString(),
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          width: width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
            child: Text(
              'GET STARTED',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 15,
                fontFamily: GoogleFonts.sora.toString(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class VitLogo extends StatelessWidget {
  const VitLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.09),
      child: SvgPicture.asset("assets/vit_logo.svg",
          color: AppColors.secondaryColor,
          height: 40,
          width: 50,
          fit: BoxFit.scaleDown),
    );
  }
}
