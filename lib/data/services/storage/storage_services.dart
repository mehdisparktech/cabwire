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
  static String myContact = "";
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
    myContact = localStorage.getString(LocalStorageKeys.myContact) ?? "";
    userType = localStorage.getString(LocalStorageKeys.userType) ?? "driver";

    // Get stored theme type
    final themeType = userType == "driver" ? "driver" : "passenger";
    theme =
        themeType == "driver" ? AppTheme.driverTheme : AppTheme.passengerTheme;

    // Try to load profile data based on user type
    if (userType == "driver") {
      final driverProfile = await getDriverProfile();
      if (driverProfile != null) {
        myName = driverProfile.name ?? myName;
        myEmail = driverProfile.email ?? myEmail;
        myImage = driverProfile.image ?? myImage;
        myContact = driverProfile.contact ?? myContact;

        // Update localStorage with these values for consistency
        await localStorage.setString(LocalStorageKeys.myName, myName);
        await localStorage.setString(LocalStorageKeys.myEmail, myEmail);
        await localStorage.setString(LocalStorageKeys.myImage, myImage);
        await localStorage.setString(LocalStorageKeys.myContact, myContact);
      }
    } else {
      final passengerProfile = await getPassengerProfile();
      if (passengerProfile != null) {
        myName = passengerProfile.name ?? myName;
        myEmail = passengerProfile.email ?? myEmail;
        myImage = passengerProfile.image ?? myImage;

        // Update localStorage with these values for consistency
        await localStorage.setString(LocalStorageKeys.myName, myName);
        await localStorage.setString(LocalStorageKeys.myEmail, myEmail);
        await localStorage.setString(LocalStorageKeys.myImage, myImage);
      }
    }

    appLog(
      "userId: $userId, userType: $userType, themeType: $themeType, theme: ${theme.toString()}, name: $myName, email: $myEmail",
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
    LocalStorage.userType = userType.name;

    // Save theme based on user type
    final themeType = userType == UserType.driver ? "driver" : "passenger";
    await localStorage.setString(LocalStorageKeys.theme, themeType);
    LocalStorage.theme =
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
    localStorage.setString(LocalStorageKeys.myContact, "");
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

  static Future<void> saveDriverProfile(DriverProfileModel profile) async {
    final localStorage = await _getStorage();
    await localStorage.setString(
      CacheKeys.driverProfile,
      json.encode(profile.toJson()),
    );

    // Update common static variables for quick access
    if (profile.name != null) {
      myName = profile.name!;
      await localStorage.setString(LocalStorageKeys.myName, myName);
    }

    if (profile.email != null) {
      myEmail = profile.email!;
      await localStorage.setString(LocalStorageKeys.myEmail, myEmail);
    }

    if (profile.image != null) {
      myImage = profile.image!;
      await localStorage.setString(LocalStorageKeys.myImage, myImage);
    }

    if (profile.contact != null) {
      myContact = profile.contact!;
      await localStorage.setString(LocalStorageKeys.myContact, myContact);
    }

    // Log the saved profile for debugging
    appLog(
      "Driver profile saved: ${profile.name}, ${profile.email}, ${profile.contact},${profile.image}",
      source: "Local Storage",
    );
    appLog(
      "Driver Local Storage profile saved: ${LocalStorage.myName}, ${LocalStorage.myEmail}, ${LocalStorage.myContact},${LocalStorage.myImage}",
      source: "Local Storage",
    );
  }

  static Future<void> savePassengerProfile(ProfileModel profile) async {
    final localStorage = await _getStorage();
    await localStorage.setString(
      CacheKeys.passengerProfile,
      json.encode(profile.toJson()),
    );

    // Update common static variables for quick access
    if (profile.name != null) {
      myName = profile.name!;
      await localStorage.setString(LocalStorageKeys.myName, myName);
    }

    if (profile.email != null) {
      myEmail = profile.email!;
      await localStorage.setString(LocalStorageKeys.myEmail, myEmail);
    }

    if (profile.image != null) {
      myImage = profile.image!;
      await localStorage.setString(LocalStorageKeys.myImage, myImage);
    }

    if (profile.contact != null) {
      myContact = profile.contact!;
      await localStorage.setString(LocalStorageKeys.myContact, myContact);
    }

    // Log the saved profile for debugging
    appLog(
      "Passenger profile saved: ${profile.name}, ${profile.email}",
      source: "Local Storage",
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

  static Future<void> removePassengerProfile() async {
    final localStorage = await _getStorage();
    await localStorage.remove(CacheKeys.passengerProfile);
  }
}
