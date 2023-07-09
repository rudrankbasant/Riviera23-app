import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/cubit/announcements/announcements_cubit.dart';
import 'package:riviera23/cubit/auth/auth_cubit.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/data/repository/hashtag_repository.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:riviera23/utils/app_theme.dart';
import 'package:riviera23/utils/constants/strings/shared_pref_keys.dart';
import 'package:riviera23/utils/constants/strings/strings.dart';
import 'package:riviera23/utils/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/events/events_cubit.dart';
import 'cubit/hashtag/hashtag_cubit.dart';
import 'cubit/merch/merch_cubit.dart';
import 'cubit/venue/venue_cubit.dart';
import 'data/models/data_version.dart';
import 'data/repository/events_repository.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");
  //Check for data updates
  await getDataUpdate();
  await setAppStarted();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'riviera_notif_channel', // id
      'Riviera 2023', // title
      // description
      importance: Importance.high,
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
                icon: "@drawable/ic_notif_icon",
                importance: Importance.high,
                // other properties...
              ),
            ));
      }
    });
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Setting SysemUIOverlay
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: AppColors.primaryColor,
    statusBarColor: AppColors.primaryColor,
    statusBarIconBrightness:
        Platform.isAndroid ? Brightness.light : Brightness.dark,
  ));

//Setting SystemUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventsCubit(EventsRepository()),
        ),
        BlocProvider(create: (context) => AnnouncementsCubit()),
        BlocProvider(create: (context) => VenueCubit()),
        BlocProvider(create: (context) => HashtagCubit(HashtagRepository())),
        BlocProvider(create: (context) => FavouriteCubit()),
        BlocProvider(create: (context) => MerchCubit()),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: AppTheme.appTheme,
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

getDataUpdate() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults({
    "android_version": "1.0.10",
    "base_url": dotenv.env['BASE_URL'],
    "ios_version": "1.0.10",
    "show_gdsc": false,
  });

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnected = await InternetConnectionChecker().hasConnection;
  if (isConnected) {
    await remoteConfig.fetchAndActivate();
    String androidVersion = remoteConfig.getString(Strings.androidVersion);
    String iosVersion = remoteConfig.getString(Strings.iosVersion);
    String baseUrl = remoteConfig.getString(Strings.baseUrl);
    bool showGdsc = remoteConfig.getBool(Strings.showGdsc);
    prefs.setString(SharedPrefKeys.idRemoteAppVersionAndroid, androidVersion);
    prefs.setString(SharedPrefKeys.idRemoteAppVersionIos, iosVersion);
    prefs.setString(SharedPrefKeys.idRemoteBaseURL, baseUrl);
    prefs.setBool(SharedPrefKeys.idRemoteShowGdsc, showGdsc);
  }

  //Check for data updates
  DataVersion remoteVersions = await getRemoteVersion();

  //All other Data Versions are int (DON'T CACHE FAVOURITES EVEN THOUGH TAKING VERSION NUMBER)
  prefs.setInt(SharedPrefKeys.idRemoteAnnouncement,
      remoteVersions.announcementVersionNumber);
  prefs.setInt(
      SharedPrefKeys.idRemoteContacts, remoteVersions.contactsVersionNumber);
  prefs.setInt(SharedPrefKeys.idRemoteFaq, remoteVersions.faqVersionNumber);
  prefs.setInt(
      SharedPrefKeys.idRemoteFav, remoteVersions.favouritesVersionNumber);
  prefs.setInt(
      SharedPrefKeys.idRemotePlaces, remoteVersions.placesVersionNumber);
  prefs.setInt(
      SharedPrefKeys.idRemoteSponsors, remoteVersions.sponsorsVersionNumber);
  prefs.setInt(SharedPrefKeys.idRemoteTeam, remoteVersions.teamVersionNumber);
  prefs.setInt(SharedPrefKeys.idRemoteMerch, remoteVersions.merchVersionNumber);
}

Future<DataVersion> getRemoteVersion() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot timelineSnapshot = await firestore
        .collection('dataversion')
        .doc('Si44DbMWkgcwGVcKcW54')
        .get();

    Map<String, dynamic> data = timelineSnapshot.data() as Map<String, dynamic>;

    DataVersion dataVersion = DataVersion.fromMap(data);

    return dataVersion;
  } catch (e) {
    return DataVersion(
        appVersionNumber: "",
        announcementVersionNumber: -1,
        contactsVersionNumber: -1,
        faqVersionNumber: -1,
        favouritesVersionNumber: -1,
        placesVersionNumber: -1,
        sponsorsVersionNumber: -1,
        teamVersionNumber: -1,
        merchVersionNumber: -1);
  }
}

Future<void> setAppStarted() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(SharedPrefKeys.appStarted, true);
  prefs.setBool(SharedPrefKeys.appStartedEvents, true);
  prefs.setBool(SharedPrefKeys.appStartedHashtags, true);
}
