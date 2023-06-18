import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme();

  static ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.primaryColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Axis'),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
