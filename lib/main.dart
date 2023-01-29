import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riviera23/cubit/announcements/announcements_cubit.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/cubit/proshows/proshows_cubit.dart';
import 'package:riviera23/data/repository/hashtag_repository.dart';
import 'package:riviera23/presentation/router/app_router.dart';
import 'package:riviera23/presentation/screens/splash_screen.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:riviera23/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/data_version/version_cubit.dart';
import 'cubit/events/events_cubit.dart';
import 'cubit/featured/featured_cubit.dart';
import 'cubit/hashtag/hashtag_cubit.dart';
import 'cubit/venue/venue_cubit.dart';
import 'data/models/data_version.dart';
import 'data/repository/events_repository.dart';
import 'data/repository/featured_repository.dart';
import 'data/repository/proshows_repository.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Check for data updates
  await getDataUpdate();
  await setAppStarted();

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

  //Setting SysemUIOverlay
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: AppColors.primaryColor,
    statusBarColor: Colors.transparent,
  ));

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VersionCubit()),
        BlocProvider(
          create: (context) => EventsCubit(EventsRepository()),
        ),
        BlocProvider(
          create: (context) => ProShowsCubit(ProShowsRepository()),
        ),
        BlocProvider(
          create: (context) => FeaturedCubit(FeaturedRepository()),
        ),
        BlocProvider(create: (context) => AnnouncementsCubit()),
        BlocProvider(create: (context) => VenueCubit()),
        BlocProvider(create: (context) => HashtagCubit(HashtagRepository())),
        BlocProvider(create: (context) => FavouriteCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Riviera23',
        theme: AppTheme.appTheme,
        home: SplashScreen(),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}

getDataUpdate() async {
  //Check for data updates
  DataVersion RemoteVersions = await getRemoteVersion();
  print("Remote Version: $RemoteVersions");

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //App Version is String
  prefs.setString("remote_app_version", RemoteVersions.app_version_number);

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
