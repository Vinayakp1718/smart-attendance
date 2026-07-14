import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        error: AppConstants.dangerColor,
        surface: AppConstants.surfaceLight,
        outline: AppConstants.borderLight,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.surfaceLight,
        foregroundColor: AppConstants.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        color: AppConstants.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.borderLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.dangerColor),
        ),
        labelStyle: const TextStyle(color: AppConstants.textSecondaryLight, fontSize: 14),
        hintStyle: const TextStyle(color: AppConstants.textSecondaryLight, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppConstants.textPrimaryLight, fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppConstants.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppConstants.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppConstants.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppConstants.textPrimaryLight, fontSize: 16),
        bodyMedium: TextStyle(color: AppConstants.textSecondaryLight, fontSize: 14),
        bodySmall: TextStyle(color: AppConstants.textSecondaryLight, fontSize: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.secondaryColor,
        secondary: AppConstants.primaryColor,
        error: AppConstants.dangerColor,
        surface: AppConstants.surfaceDark,
        outline: AppConstants.borderDark,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.surfaceDark,
        foregroundColor: AppConstants.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        color: AppConstants.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.borderDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.backgroundDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.secondaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.dangerColor),
        ),
        labelStyle: const TextStyle(color: AppConstants.textSecondaryDark, fontSize: 14),
        hintStyle: const TextStyle(color: AppConstants.textSecondaryDark, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.secondaryColor,
          foregroundColor: AppConstants.backgroundDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.secondaryColor,
          side: const BorderSide(color: AppConstants.secondaryColor),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.secondaryColor,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppConstants.textPrimaryDark, fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppConstants.textPrimaryDark, fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppConstants.textPrimaryDark, fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppConstants.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppConstants.textPrimaryDark, fontSize: 16),
        bodyMedium: TextStyle(color: AppConstants.textSecondaryDark, fontSize: 14),
        bodySmall: TextStyle(color: AppConstants.textSecondaryDark, fontSize: 12),
      ),
    );
  }
}
