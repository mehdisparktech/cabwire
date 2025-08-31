import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverTripCloseOtpShowcase {
  // Global keys for showcase targets
  static final GlobalKey appBarKey = GlobalKey();
  static final GlobalKey titleKey = GlobalKey();
  static final GlobalKey otpFieldsKey = GlobalKey();
  static final GlobalKey logoKey = GlobalKey();
  static final GlobalKey actionButtonKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey =
      'driver_trip_close_otp_tutorial_shown';

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
        appBarKey,
        titleKey,
        otpFieldsKey,
        logoKey,
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

  /// Build showcase wrapper for app bar
  static Widget buildAppBarShowcase({required Widget child}) {
    return Showcase(
      key: appBarKey,
      title: 'Trip Closure OTP',
      description:
          'This screen helps you complete the trip securely. The app bar shows you\'re on the Trip Closure OTP page for final verification.',
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for title
  static Widget buildTitleShowcase({required Widget child}) {
    return Showcase(
      key: titleKey,
      title: 'Trip Completion Instructions',
      description:
          'This title explains the final step. Ask the passenger for their trip closure OTP to officially end the ride and process payment.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for OTP fields
  static Widget buildOtpFieldsShowcase({required Widget child}) {
    return Showcase(
      key: otpFieldsKey,
      title: 'Enter Closure OTP',
      description:
          'Enter the 4-digit closure OTP provided by the passenger at the destination. This verifies successful trip completion.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for logo
  static Widget buildLogoShowcase({required Widget child}) {
    return Showcase(
      key: logoKey,
      title: 'Secure Transaction',
      description:
          'The Cabwire logo ensures this is a secure, official transaction. Your earnings will be processed safely through our platform.',
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for action button
  static Widget buildActionButtonShowcase({required Widget child}) {
    return Showcase(
      key: actionButtonKey,
      title: 'Complete Trip',
      description:
          'After entering the correct closure OTP, tap this button to officially end the trip, process payment, and update your earnings.',
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
