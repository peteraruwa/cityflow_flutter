import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData buildCityFlowTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Sora',
    primaryColor: kPurple,
    scaffoldBackgroundColor: kBackground,
    colorScheme: const ColorScheme.dark(
      primary: kPurple,
      secondary: kGold,
      surface: kBackground,
      onPrimary: kCream,
      onSecondary: kBackground,
      onSurface: kCream,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: kCream,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: kCream,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: kCream,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPurple,
        foregroundColor: kCream,
      ),
    ),
  );
}
