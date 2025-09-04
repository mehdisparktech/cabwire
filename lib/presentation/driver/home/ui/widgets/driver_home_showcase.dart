import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHomeShowcase {
  // Global keys for showcase targets
  static final GlobalKey profileKey = GlobalKey();
  static final GlobalKey onlineStatusKey = GlobalKey();
  static final GlobalKey notificationKey = GlobalKey();
  static final GlobalKey mapKey = GlobalKey();
  static final GlobalKey rideRequestKey = GlobalKey();
  static final GlobalKey actionButtonsKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'driver_home_tutorial_shown';

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
        onlineStatusKey,
        notificationKey,
        mapKey,
        rideRequestKey,
        actionButtonsKey,
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
          'Your profile picture and name are displayed here. Tap to view and edit your driver profile information.',
      targetShapeBorder: const CircleBorder(),
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(50.px),
      child: child,
    );
  }

  /// Build showcase wrapper for online/offline status toggle
  static Widget buildOnlineStatusShowcase({required Widget child}) {
    return Showcase(
      key: onlineStatusKey,
      title: 'Online Status',
      description:
          'Toggle your online status here. When online, you\'ll receive ride requests. When offline, you won\'t get any requests.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(20.px),
      child: child,
    );
  }

  /// Build showcase wrapper for notification button
  static Widget buildNotificationShowcase({required Widget child}) {
    return Showcase(
      key: notificationKey,
      title: 'Notifications',
      description:
          'Stay updated with ride notifications, passenger messages, earnings updates, and important driver announcements.',
      targetShapeBorder: const CircleBorder(),
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(25.px),
      child: child,
    );
  }

  /// Build showcase wrapper for map area
  static Widget buildMapShowcase({required Widget child}) {
    return Showcase(
      key: mapKey,
      title: 'Driver Map',
      description:
          'This map shows your current location and nearby ride requests. You can see pickup and drop-off locations when you receive requests.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(24.px),
      child: child,
    );
  }

  /// Build showcase wrapper for ride request cards
  static Widget buildRideRequestShowcase({required Widget child}) {
    return Showcase(
      key: rideRequestKey,
      title: 'Ride Requests',
      description:
          'When you\'re online, ride requests will appear here. You can see passenger details, pickup/drop-off locations, estimated fare, and trip duration.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(20.px),
      child: child,
    );
  }

  /// Build showcase wrapper for action buttons (Accept/Decline)
  static Widget buildActionButtonsShowcase({required Widget child}) {
    return Showcase(
      key: actionButtonsKey,
      title: 'Accept or Decline',
      description:
          'Use these buttons to accept or decline ride requests. Accepting a ride will start your trip with the passenger.',
      tooltipBackgroundColor: Colors.red.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
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
