import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCarTypeShowcase {
  // Global keys for showcase targets
  static final GlobalKey mapKey = GlobalKey();
  static final GlobalKey appBarKey = GlobalKey();
  static final GlobalKey carCategoriesKey = GlobalKey();
  static final GlobalKey paymentMethodKey = GlobalKey();
  static final GlobalKey findCarButtonKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'choose_car_type_tutorial_shown';

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
        appBarKey,
        carCategoriesKey,
        paymentMethodKey,
        findCarButtonKey,
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
      title: 'Route Preview',
      description:
          'This map shows your pickup and drop-off locations. You can see the route that will be taken for your trip.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for app bar
  static Widget buildAppBarShowcase({required Widget child}) {
    return Showcase(
      key: appBarKey,
      title: 'Car Booking Options',
      description:
          'This is where you choose your preferred car type and payment method. Use the back button to return to the previous screen.',
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12.px),
      child: child,
    );
  }

  /// Build showcase wrapper for car categories
  static Widget buildCarCategoriesShowcase({required Widget child}) {
    return Showcase(
      key: carCategoriesKey,
      title: 'Choose Your Car Type',
      description:
          'Select from different car categories based on your needs and budget. Each option shows the estimated fare and vehicle type.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12.px),
      child: child,
    );
  }

  /// Build showcase wrapper for payment method
  static Widget buildPaymentMethodShowcase({required Widget child}) {
    return Showcase(
      key: paymentMethodKey,
      title: 'Payment Options',
      description:
          'Choose how you\'d like to pay for your ride. Online payment is recommended for a seamless experience, or you can pay with cash.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12.px),
      child: child,
    );
  }

  /// Build showcase wrapper for find car button
  static Widget buildFindCarButtonShowcase({required Widget child}) {
    return Showcase(
      key: findCarButtonKey,
      title: 'Book Your Ride',
      description:
          'Once you\'ve selected your car type and payment method, tap this button to find available drivers and book your ride.',
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
