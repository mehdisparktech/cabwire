import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/config/app_theme_color.dart';
import 'package:cabwire/core/static/font_family.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    extensions: const [AppThemeColor.light],
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
    extensions: const [AppThemeColor.passenger],
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
  );

  static ThemeData driverTheme = ThemeData(
    extensions: const [AppThemeColor.driver],
    fontFamily: FontFamily.outfit,
    scaffoldBackgroundColor: AppColor.background,
    primaryColor: AppColor.primary,
  );
}
