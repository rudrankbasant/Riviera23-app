import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/announcements/announcements_cubit.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/cubit/proshows/proshows_cubit.dart';
import 'package:riviera23/data/repository/hashtag_repository.dart';
import 'package:riviera23/presentation/screens/splash_screen.dart';
import 'package:riviera23/utils/app_theme.dart';

import 'cubit/events/events_cubit.dart';
import 'cubit/featured/featured_cubit.dart';
import 'cubit/hashtag/hashtag_cubit.dart';
import 'data/repository/events_repository.dart';
import 'data/repository/featured_repository.dart';
import 'data/repository/proshows_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(MyApp());
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
        BlocProvider(
          create: (context) => ProShowsCubit(ProShowsRepository()),
        ),
        BlocProvider(
          create: (context) => FeaturedCubit(FeaturedRepository()),
        ),
        BlocProvider(
          create: (context) => AnnouncementsCubit(),
        ),
        BlocProvider(create: (context) => HashtagCubit(HashtagRepository())),
        BlocProvider(
            create: (context)=> FavouriteCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Riviera23',
        theme: AppTheme.appTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
