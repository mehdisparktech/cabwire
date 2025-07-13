import 'dart:convert';
import 'package:cabwire/core/enum/user_type.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/services/local_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabwire/core/config/themes.dart';
import 'storage_keys.dart';

class LocalStorage {
  static String token = "";
  static String cookie = "";
  static String refreshToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String userType = "";
  static ThemeData theme = AppTheme.lightTheme;
  // Create Local Storage Instance
  static SharedPreferences? preferences;

  /// Get SharedPreferences Instance
  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  /// Get All Data From SharedPreferences
  static Future<void> getAllPrefData() async {
    final localStorage = await _getStorage();

    token = localStorage.getString(LocalStorageKeys.token) ?? "";
    cookie = localStorage.getString(LocalStorageKeys.cookie) ?? "";
    refreshToken = localStorage.getString(LocalStorageKeys.refreshToken) ?? "";
    isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
    userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
    myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
    myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
    myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";
    userType = localStorage.getString(LocalStorageKeys.userType) ?? "driver";
    // Get stored theme type
    final themeType = userType == "driver" ? "driver" : "passenger";
    theme =
        themeType == "driver" ? AppTheme.driverTheme : AppTheme.passengerTheme;

    appLog(
      "userId: $userId, userType: $userType, themeType: $themeType, theme: ${theme.toString()}",
      source: "Local Storage",
    );
  }

  /// Save token and user data
  static Future<void> saveLoginData(
    String authToken,
    UserType userType,
    ThemeData theme,
  ) async {
    final localStorage = await _getStorage();

    // Save token
    await localStorage.setString(LocalStorageKeys.token, authToken);
    token = authToken;

    // Save user type
    await localStorage.setString(LocalStorageKeys.userType, userType.name);
    userType = userType;

    // Save theme based on user type
    final themeType = userType == UserType.driver ? "driver" : "passenger";
    await localStorage.setString(LocalStorageKeys.theme, themeType);
    theme =
        themeType == "driver" ? AppTheme.driverTheme : AppTheme.passengerTheme;

    // Parse JWT to get user data
    try {
      final parts = authToken.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );

        // Save user data from token
        await localStorage.setString(
          LocalStorageKeys.userId,
          payload['id'] ?? '',
        );
        await localStorage.setString(
          LocalStorageKeys.myEmail,
          payload['email'] ?? '',
        );
        await localStorage.setBool(LocalStorageKeys.isLogIn, true);

        // Update static variables
        userId = payload['id'] ?? '';
        myEmail = payload['email'] ?? '';
        isLogIn = true;
      }
    } catch (e) {
      appLog('Error parsing JWT: $e', source: "Local Storage");
    }
  }

  /// Check if token is expired
  static bool isTokenExpired() {
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );

        final exp = payload['exp'];
        if (exp != null) {
          final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
          return DateTime.now().isAfter(expiry);
        }
      }
      return true; // If we can't verify, assume it's expired
    } catch (e) {
      appLog('Error checking token expiry: $e', source: "Local Storage");
      return true;
    }
  }

  /// Remove All Data From SharedPreferences
  static Future<void> removeAllPrefData() async {
    final localStorage = await _getStorage();
    await localStorage.clear();
    _resetLocalStorageData();
    await getAllPrefData();
  }

  // Reset LocalStorage Data
  static void _resetLocalStorageData() {
    final localStorage = preferences!;
    localStorage.setString(LocalStorageKeys.token, "");
    localStorage.setString(LocalStorageKeys.cookie, "");
    localStorage.setString(LocalStorageKeys.refreshToken, "");
    localStorage.setString(LocalStorageKeys.userId, "");
    localStorage.setString(LocalStorageKeys.myImage, "");
    localStorage.setString(LocalStorageKeys.myName, "");
    localStorage.setString(LocalStorageKeys.myEmail, "");
    localStorage.setBool(LocalStorageKeys.isLogIn, false);
    localStorage.setString(LocalStorageKeys.theme, "light");
  }

  // Save Data To SharedPreferences
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    final localStorage = await _getStorage();
    await localStorage.setInt(key, value);
  }

  static Future<void> saveDriverProfile(ProfileModel profile) async {
    final localStorage = await _getStorage();
    await localStorage.setString(
      CacheKeys.driverProfile,
      json.encode(profile.toJson()),
    );
  }

  static Future<DriverProfileModel?> getDriverProfile() async {
    final localStorage = await _getStorage();
    final profile = localStorage.getString(CacheKeys.driverProfile);
    return profile != null
        ? DriverProfileModel.fromJson(json.decode(profile))
        : null;
  }

  static Future<ProfileModel?> getPassengerProfile() async {
    final localStorage = await _getStorage();
    final profile = localStorage.getString(CacheKeys.passengerProfile);
    return profile != null ? ProfileModel.fromJson(json.decode(profile)) : null;
  }

  static Future<void> removeDriverProfile() async {
    final localStorage = await _getStorage();
    await localStorage.remove(CacheKeys.driverProfile);
  }
}
