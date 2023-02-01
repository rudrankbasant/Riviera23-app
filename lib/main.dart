import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riviera23/cubit/announcements/announcements_cubit.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/data/repository/hashtag_repository.dart';
import 'package:riviera23/presentation/router/app_router.dart';
import 'package:riviera23/presentation/screens/splash_screen.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:riviera23/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/data_version/version_cubit.dart';
import 'cubit/events/events_cubit.dart';
import 'cubit/hashtag/hashtag_cubit.dart';
import 'cubit/venue/venue_cubit.dart';
import 'data/models/data_version.dart';
import 'data/repository/events_repository.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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


