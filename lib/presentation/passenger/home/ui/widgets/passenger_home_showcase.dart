import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerHomeShowcase {
  // Global keys for showcase targets
  static final GlobalKey profileKey = GlobalKey();
  static final GlobalKey locationKey = GlobalKey();
  static final GlobalKey notificationKey = GlobalKey();
  static final GlobalKey rideBookingKey = GlobalKey();
  static final GlobalKey servicesKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'passenger_home_tutorial_shown';

  /// Check if tutorial should be shown (first time user)
  static Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_tutorialShownKey) ?? false);
  }

  /// Mark tutorial as completed
  static Future<void> markTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialShownKey, true);
  }

  /// Start the showcase tutorial
  static void startShowcase(BuildContext context) {
    // Use a more robust approach with multiple fallbacks
    _attemptStartShowcase(context, 0);
  }

  /// Attempt to start showcase with retry logic
  static void _attemptStartShowcase(BuildContext context, int attempt) {
    if (attempt > 3) {
      if (kDebugMode) {
        print('Failed to start showcase after 3 attempts');
      }
      return;
    }

    try {
      final showcaseWidget = ShowCaseWidget.of(context);
      showcaseWidget.startShowCase([
        profileKey,
        locationKey,
        notificationKey,
        rideBookingKey,
        servicesKey,
      ]);
      if (kDebugMode) {
        print('Showcase started successfully on attempt ${attempt + 1}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Showcase attempt ${attempt + 1} failed: $e');
      }
      // Retry with increasing delay
      final delay = Duration(milliseconds: 500 * (attempt + 1));
      Future.delayed(delay, () {
        if (context.mounted) {
          _attemptStartShowcase(context, attempt + 1);
        }
      });
    }
  }

  /// Build showcase wrapper for profile section
  static Widget buildProfileShowcase({required Widget child}) {
    return Showcase(
      key: profileKey,
      title: 'Your Profile',
      description:
          'Tap here to view and edit your profile information. Your profile picture and name are displayed here.',
      targetShapeBorder: const CircleBorder(),
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(50.px),
      child: child,
    );
  }

  /// Build showcase wrapper for location section
  static Widget buildLocationShowcase({required Widget child}) {
    return Showcase(
      key: locationKey,
      title: 'Current Location',
      description:
          'This shows your current location. Make sure location services are enabled for accurate pickup.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for notification button
  static Widget buildNotificationShowcase({required Widget child}) {
    return Showcase(
      key: notificationKey,
      title: 'Notifications',
      description:
          'Stay updated with ride notifications, driver messages, and important updates.',
      targetShapeBorder: const CircleBorder(),
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(25.px),
      child: child,
    );
  }

  /// Build showcase wrapper for ride booking widget
  static Widget buildRideBookingShowcase({required Widget child}) {
    return Showcase(
      key: rideBookingKey,
      title: 'Book a Ride',
      description:
          'Tap here to start booking your ride. Enter your destination and choose your preferred service.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12.px),
      child: child,
    );
  }

  /// Build showcase wrapper for services section
  static Widget buildServicesShowcase({required Widget child}) {
    return Showcase(
      key: servicesKey,
      title: 'Available Services',
      description:
          'Choose from various services like regular car booking, emergency rides, rental cars, and package delivery.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(16.px),
      child: child,
    );
  }

  /// Check if ShowCaseWidget is ready in the given context
  static bool isShowCaseReady(BuildContext context) {
    try {
      ShowCaseWidget.of(context);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reset tutorial (for testing purposes)
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialShownKey);
  }
}
