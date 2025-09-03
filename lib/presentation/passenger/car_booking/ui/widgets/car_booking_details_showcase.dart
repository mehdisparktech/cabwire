import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarBookingDetailsShowcase {
  // Global keys for showcase targets
  static final GlobalKey appBarKey = GlobalKey();
  static final GlobalKey passengerInfoKey = GlobalKey();
  static final GlobalKey vehicleInfoKey = GlobalKey();
  static final GlobalKey tripRouteKey = GlobalKey();
  static final GlobalKey tripStatsKey = GlobalKey();
  static final GlobalKey paymentInfoKey = GlobalKey();
  static final GlobalKey feedbackKey = GlobalKey();
  static final GlobalKey actionButtonKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'car_booking_details_tutorial_shown';

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
        passengerInfoKey,
        vehicleInfoKey,
        tripRouteKey,
        tripStatsKey,
        paymentInfoKey,
        feedbackKey,
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
      title: 'Trip Details',
      description:
          'This screen shows comprehensive details about your completed or ongoing trip. Review all trip information here.',
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for passenger info
  static Widget buildPassengerInfoShowcase({required Widget child}) {
    return Showcase(
      key: passengerInfoKey,
      title: 'Passenger Information',
      description:
          'Your profile information and pickup location are displayed here. This helps identify you to the driver.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for vehicle info
  static Widget buildVehicleInfoShowcase({required Widget child}) {
    return Showcase(
      key: vehicleInfoKey,
      title: 'Vehicle Details',
      description:
          'View your assigned vehicle\'s license plate number and model. Use this information to identify your ride.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for trip route
  static Widget buildTripRouteShowcase({required Widget child}) {
    return Showcase(
      key: tripRouteKey,
      title: 'Trip Route',
      description:
          'This section shows your complete trip route from pickup to drop-off location, helping you track your journey.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for trip statistics
  static Widget buildTripStatsShowcase({required Widget child}) {
    return Showcase(
      key: tripStatsKey,
      title: 'Trip Statistics',
      description:
          'View important trip metrics including total distance traveled and estimated travel time for your records.',
      tooltipBackgroundColor: Colors.indigo.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for payment info
  static Widget buildPaymentInfoShowcase({required Widget child}) {
    return Showcase(
      key: paymentInfoKey,
      title: 'Payment Information',
      description:
          'Review your payment method and total fare amount. This shows how you paid or will pay for your trip.',
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for feedback
  static Widget buildFeedbackShowcase({required Widget child}) {
    return Showcase(
      key: feedbackKey,
      title: 'Trip Feedback',
      description:
          'Share your experience by providing feedback about your trip. Your input helps us improve our service quality.',
      tooltipBackgroundColor: Colors.amber.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for action button
  static Widget buildActionButtonShowcase({required Widget child}) {
    return Showcase(
      key: actionButtonKey,
      title: 'Complete Transaction',
      description:
          'Use this button to complete payment (for online payments) or submit your feedback (for cash payments) to finish your trip.',
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
