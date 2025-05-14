import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_theme_color.dart';
import 'package:cabwire/core/static/font_family.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    extensions: [AppThemeColor.light],
    fontFamily: FontFamily.outfit,
    scaffoldBackgroundColor: AppColor.background,
    primaryColor: AppColor.primary,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.primary,
      error: AppColor.danger,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.background,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColor.textPrimary,
        fontFamily: FontFamily.outfit,
        height: 1.6,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.background,
      indicatorColor: AppColor.primary,
      height: 80,
      labelTextStyle: WidgetStateTextStyle.resolveWith(
        (states) => TextStyle(
          fontWeight:
              states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.normal,
          fontSize: 12,
          color:
              states.contains(WidgetState.selected)
                  ? AppColor.primary
                  : AppColor.textSecondary,
        ),
      ),
    ),
  );

  static ThemeData passengerTheme = ThemeData(
    extensions: [AppThemeColor.passenger],
    fontFamily: FontFamily.outfit,
    scaffoldBackgroundColor: AppColor.background,
    primaryColor: AppColor.primary,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.primary,
      secondary: AppColor.secondary,
      surface: AppColor.background,
      onSurface: AppColor.textPrimary,
      onPrimary: AppColor.textPrimary,
      onSecondary: AppColor.textPrimary,
      onError: AppColor.danger,
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColor.black, // Changed from textBlack87 for stronger titles
      ),
      titleMedium: TextStyle(fontSize: 16, color: AppColor.textBlack87),
      bodyLarge: TextStyle(color: AppColor.textBlack87),
      labelLarge: TextStyle(
        // For button text
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
        fontFamily: FontFamily.outfit,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      hintStyle: TextStyle(
        color: AppColor.textHint,
        fontFamily: FontFamily.outfit,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontFamily: FontFamily.outfit,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: FontFamily.outfit,
        ),
        minimumSize: Size.zero,
        padding: const EdgeInsets.only(left: 4), // As per original
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );

  // Driver Theme

  static ThemeData driverTheme = ThemeData(
    extensions: [AppThemeColor.driver],
    fontFamily: FontFamily.outfit,
    scaffoldBackgroundColor: AppColor.background,
    primaryColor: AppColor.driverButtonPrimaryStart,
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.driverButtonPrimaryStart,
      secondary: AppColor.secondary,
      surface: AppColor.background,
      onSurface: AppColor.textPrimary,
      onPrimary: AppColor.textPrimary,
      onSecondary: AppColor.textPrimary,
      onError: AppColor.danger,
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColor.black, // Changed from textBlack87 for stronger titles
      ),
      titleMedium: TextStyle(fontSize: 16, color: AppColor.textBlack87),
      bodyLarge: TextStyle(color: AppColor.textBlack87),
      labelLarge: TextStyle(
        // For button text
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
        fontFamily: FontFamily.outfit,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.driverButtonPrimaryStart),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.driverButtonPrimaryStart),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.driverButtonPrimaryStart),
      ),
      hintStyle: TextStyle(
        color: AppColor.textHint,
        fontFamily: FontFamily.outfit,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.driverButtonPrimaryStart,
        foregroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontFamily: FontFamily.outfit,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.driverButtonPrimaryStart,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: FontFamily.outfit,
        ),
        minimumSize: Size.zero,
        padding: const EdgeInsets.only(left: 4), // As per original
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );
}
