import 'package:flutter/material.dart';
import 'package:riviera23/presentation/screens/events_screen.dart';
import 'package:riviera23/presentation/screens/home_screen.dart';
import 'package:riviera23/presentation/screens/info_screen.dart';
import 'package:riviera23/presentation/screens/profile_screen.dart';

import '../screens/hashtags_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (homeContext) {
          return const SplashScreen();
        });
      case '/home':
        return MaterialPageRoute(builder: (_) {
          return const HomeScreen(null);
        });
      case '/events/all':
        return MaterialPageRoute(builder: (_) {
          return EventsScreen(0);
        });
      case '/events/favourites':
        return MaterialPageRoute(builder: (_) {
          return EventsScreen(1);
        });
      case '/hashtags':
        return MaterialPageRoute(builder: (_) {
          return const HashtagsScreen();
        });
      case '/info':
        return MaterialPageRoute(builder: (_) {
          return const InfoScreen();
        });
      case '/profile':
        return MaterialPageRoute(builder: (_) {
          return const ProfileScreen();
        });
      default:
        return MaterialPageRoute(builder: (_) {
          return Container();
        });
    }
  }
}
