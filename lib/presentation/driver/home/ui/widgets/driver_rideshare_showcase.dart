import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverRideshareShowcase {
  // Global keys for showcase targets
  static final GlobalKey topNavigationKey = GlobalKey();
  static final GlobalKey mapKey = GlobalKey();
  static final GlobalKey pickupInfoKey = GlobalKey();
  static final GlobalKey passengerInfoKey = GlobalKey();
  static final GlobalKey messageCallKey = GlobalKey();
  static final GlobalKey tripStoppageKey = GlobalKey();
  static final GlobalKey actionButtonKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'driver_rideshare_tutorial_shown';

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
        topNavigationKey,
        mapKey,
        pickupInfoKey,
        passengerInfoKey,
        messageCallKey,
        tripStoppageKey,
        actionButtonKey,
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

  /// Build showcase wrapper for top navigation
  static Widget buildTopNavigationShowcase({required Widget child}) {
    return Showcase(
      key: topNavigationKey,
      title: 'Trip Navigation',
      description:
          'This shows your current trip details including distance and destination address. Use the back button to return to the previous screen.',
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12.px),
      child: child,
    );
  }

  /// Build showcase wrapper for map
  static Widget buildMapShowcase({required Widget child}) {
    return Showcase(
      key: mapKey,
      title: 'Trip Route Map',
      description:
          'This map shows the route to your passenger\'s pickup location and the trip route. Follow the blue line to navigate efficiently.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for pickup info
  static Widget buildPickupInfoShowcase({required Widget child}) {
    return Showcase(
      key: pickupInfoKey,
      title: 'Trip Status & Timer',
      description:
          'This shows your current trip status and estimated time. It updates as you progress through pickup, start, and completion phases.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for passenger info
  static Widget buildPassengerInfoShowcase({required Widget child}) {
    return Showcase(
      key: passengerInfoKey,
      title: 'Passenger Details',
      description:
          'View passenger information including name, pickup address, and trip distance. This helps you identify and locate your passenger.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for message and call buttons
  static Widget buildMessageCallShowcase({required Widget child}) {
    return Showcase(
      key: messageCallKey,
      title: 'Communication Options',
      description:
          'Use these buttons to message or call your passenger. Communication helps coordinate pickup and ensures a smooth trip experience.',
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for trip stoppage info
  static Widget buildTripStoppageShowcase({required Widget child}) {
    return Showcase(
      key: tripStoppageKey,
      title: 'Destination Information',
      description:
          'This shows the passenger\'s drop-off location. Make sure you know where you\'re heading before starting the trip.',
      tooltipBackgroundColor: Colors.indigo.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for action button
  static Widget buildActionButtonShowcase({required Widget child}) {
    return Showcase(
      key: actionButtonKey,
      title: 'Trip Actions',
      description:
          'Use this button to start the ride once you\'ve picked up the passenger, or to complete the trip when you reach the destination.',
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
