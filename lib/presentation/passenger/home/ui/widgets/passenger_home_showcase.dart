import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerHomeShowcase {
  // Global keys for showcase targets - using unique identifiers to avoid conflicts
  static GlobalKey? _profileKey;
  static GlobalKey? _locationKey;
  static GlobalKey? _notificationKey;
  static GlobalKey? _rideBookingKey;
  static GlobalKey? _servicesKey;

  // Getters that create keys lazily to avoid conflicts
  static GlobalKey get profileKey {
    _profileKey ??= GlobalKey(
      debugLabel: 'showcase_profile_${DateTime.now().millisecondsSinceEpoch}',
    );
    return _profileKey!;
  }

  static GlobalKey get locationKey {
    _locationKey ??= GlobalKey(
      debugLabel: 'showcase_location_${DateTime.now().millisecondsSinceEpoch}',
    );
    return _locationKey!;
  }

  static GlobalKey get notificationKey {
    _notificationKey ??= GlobalKey(
      debugLabel:
          'showcase_notification_${DateTime.now().millisecondsSinceEpoch}',
    );
    return _notificationKey!;
  }

  static GlobalKey get rideBookingKey {
    _rideBookingKey ??= GlobalKey(
      debugLabel:
          'showcase_ride_booking_${DateTime.now().millisecondsSinceEpoch}',
    );
    return _rideBookingKey!;
  }

  static GlobalKey get servicesKey {
    _servicesKey ??= GlobalKey(
      debugLabel: 'showcase_services_${DateTime.now().millisecondsSinceEpoch}',
    );
    return _servicesKey!;
  }

  /// Reset keys (useful for testing or when recreating widgets)
  static void resetKeys() {
    _profileKey = null;
    _locationKey = null;
    _notificationKey = null;
    _rideBookingKey = null;
    _servicesKey = null;
  }

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
    try {
      // Use a more robust approach with multiple fallbacks
      _attemptStartShowcase(context, 0);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to start showcase: $e');
      }
      // Mark as completed to prevent repeated attempts
      markTutorialCompleted();
    }
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
      // Verify all keys are attached to widgets before starting
      if (!_areAllKeysAttached()) {
        if (kDebugMode) {
          print('Not all showcase keys are attached, retrying...');
        }
        final delay = Duration(milliseconds: 300 * (attempt + 1));
        Future.delayed(delay, () {
          if (context.mounted) {
            _attemptStartShowcase(context, attempt + 1);
          }
        });
        return;
      }

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

  /// Check if all showcase keys are attached to widgets
  static bool _areAllKeysAttached() {
    final keys = [
      profileKey,
      locationKey,
      notificationKey,
      rideBookingKey,
      servicesKey,
    ];
    return keys.every((key) => key.currentContext != null);
  }

  /// Build showcase wrapper for profile section
  static Widget buildProfileShowcase({required Widget child}) {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error building profile showcase: $e');
      }
      return child; // Return child without showcase if there's an error
    }
  }

  /// Build showcase wrapper for location section
  static Widget buildLocationShowcase({required Widget child}) {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error building location showcase: $e');
      }
      return child;
    }
  }

  /// Build showcase wrapper for notification button
  static Widget buildNotificationShowcase({required Widget child}) {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error building notification showcase: $e');
      }
      return child;
    }
  }

  /// Build showcase wrapper for ride booking widget
  static Widget buildRideBookingShowcase({required Widget child}) {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error building ride booking showcase: $e');
      }
      return child;
    }
  }

  /// Build showcase wrapper for services section
  static Widget buildServicesShowcase({required Widget child}) {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error building services showcase: $e');
      }
      return child;
    }
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
