import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme();

  static ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.secondaryColor,
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
