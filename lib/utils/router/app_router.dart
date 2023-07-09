import 'package:flutter/material.dart';
import 'package:riviera23/presentation/screens/announcement_history_screen.dart';
import 'package:riviera23/presentation/screens/auth_screen.dart';
import 'package:riviera23/presentation/screens/bottom_nav_screen.dart';
import 'package:riviera23/presentation/screens/events_screen.dart';
import 'package:riviera23/presentation/screens/merch_screen.dart';

import '../../presentation/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (homeContext) {
          return const SplashScreen();
        });
      case '/bottomNavScreen':
        return MaterialPageRoute(builder: (homeContext) {
          return BottomNavScreen(args as int?);
        });
      case '/authentication':
        return MaterialPageRoute(builder: (_) {
          return const AuthScreen();
        });
      case '/announcements':
        return MaterialPageRoute(builder: (_) {
          return const AnnouncementHistoryScreen();
        });
      case '/merch':
        return MaterialPageRoute(builder: (_) {
          return const MerchScreen();
        });
      case '/events':
        return MaterialPageRoute(builder: (homeContext) {
          return EventsScreen(args as int?);
        });
      default:
        return MaterialPageRoute(builder: (_) {
          return const Center(
            child: Text('Page Not Found'),
          );
        });
    }
  }
}
