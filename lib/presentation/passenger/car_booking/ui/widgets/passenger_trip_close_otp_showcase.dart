import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerTripCloseOtpShowcase {
  // Global keys for showcase targets
  static final GlobalKey appBarKey = GlobalKey();
  static final GlobalKey titleKey = GlobalKey();
  static final GlobalKey otpFieldsKey = GlobalKey();
  static final GlobalKey warningTextKey = GlobalKey();
  static final GlobalKey logoKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey =
      'passenger_trip_close_otp_tutorial_shown';

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
        warningTextKey,
        logoKey,
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
          'This screen shows your trip closure OTP. You\'ll share this code with your driver when your trip is complete.',
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
      title: 'Share OTP Instructions',
      description:
          'This title reminds you to share the OTP with your driver. Only share it when you\'ve safely reached your destination.',
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
      title: 'Your Trip Closure OTP',
      description:
          'This is your unique 4-digit OTP for trip completion. Share this code with your driver only when you reach your destination.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for warning text
  static Widget buildWarningTextShowcase({required Widget child}) {
    return Showcase(
      key: warningTextKey,
      title: 'Important Security Notice',
      description:
          'This warning protects you from fraud. Never share your OTP until you\'ve safely arrived at your destination.',
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for logo
  static Widget buildLogoShowcase({required Widget child}) {
    return Showcase(
      key: logoKey,
      title: 'Secure Trip Completion',
      description:
          'The Cabwire logo ensures this is an official, secure trip completion process. Your safety and security are our priority.',
      tooltipBackgroundColor: Colors.teal.shade700,
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
