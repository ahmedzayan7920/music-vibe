import 'package:flutter/material.dart';

abstract class AppThemes {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5722), // Sonic Orange
      brightness: Brightness.dark,
      primary: const Color(0xFFFF5722),
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFAB00), // Amber Accent
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      tertiary: const Color(0xFFFF5722),
      onTertiary: Colors.black,
      surfaceContainer: const Color(0xFF1A1A1A),
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5722),
      brightness: Brightness.light,
      primary: const Color(0xFFFF5722),
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFAB00),
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      tertiary: const Color(0xFFFF5722),
      onTertiary: Colors.white,
      surfaceContainer: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
