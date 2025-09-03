import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerRideshareShowcase {
  // Global keys for showcase targets
  static final GlobalKey mapKey = GlobalKey();
  static final GlobalKey bottomSheetKey = GlobalKey();
  static final GlobalKey tripStatusKey = GlobalKey();
  static final GlobalKey driverInfoKey = GlobalKey();
  static final GlobalKey communicationKey = GlobalKey();
  static final GlobalKey tripDetailsKey = GlobalKey();
  static final GlobalKey actionButtonKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'passenger_rideshare_tutorial_shown';

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
        mapKey,
        bottomSheetKey,
        tripStatusKey,
        driverInfoKey,
        communicationKey,
        tripDetailsKey,
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

  /// Build showcase wrapper for map
  static Widget buildMapShowcase({required Widget child}) {
    return Showcase(
      key: mapKey,
      title: 'Live Trip Tracking',
      description:
          'Track your ride in real-time. See your current location, driver\'s position, and the route to your destination.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for bottom sheet
  static Widget buildBottomSheetShowcase({required Widget child}) {
    return Showcase(
      key: bottomSheetKey,
      title: 'Trip Information Panel',
      description:
          'This panel shows all your trip details. You can drag it up or down to see more or less information.',
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(16.px),
      child: child,
    );
  }

  /// Build showcase wrapper for trip status
  static Widget buildTripStatusShowcase({required Widget child}) {
    return Showcase(
      key: tripStatusKey,
      title: 'Trip Status',
      description:
          'Monitor your trip progress here. See estimated arrival time and current trip phase (pickup, in progress, or completion).',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for driver info
  static Widget buildDriverInfoShowcase({required Widget child}) {
    return Showcase(
      key: driverInfoKey,
      title: 'Driver Information',
      description:
          'View your driver\'s details including name, photo, vehicle information, and rating for your safety and peace of mind.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for communication options
  static Widget buildCommunicationShowcase({required Widget child}) {
    return Showcase(
      key: communicationKey,
      title: 'Contact Driver',
      description:
          'Use these options to message or call your driver for coordination, special instructions, or any concerns during your trip.',
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for trip details
  static Widget buildTripDetailsShowcase({required Widget child}) {
    return Showcase(
      key: tripDetailsKey,
      title: 'Trip Summary',
      description:
          'View important trip information including pickup and drop-off locations, estimated fare, and trip duration.',
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
          'Use this button for trip-related actions like sharing your OTP with the driver or completing payment after the ride.',
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
