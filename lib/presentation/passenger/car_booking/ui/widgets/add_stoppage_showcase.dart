import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStoppageShowcase {
  // Global keys for showcase targets
  static final GlobalKey appBarKey = GlobalKey();
  static final GlobalKey mapKey = GlobalKey();
  static final GlobalKey searchInputsKey = GlobalKey();
  static final GlobalKey routeInfoKey = GlobalKey();
  static final GlobalKey suggestionsKey = GlobalKey();
  static final GlobalKey confirmButtonKey = GlobalKey();

  // SharedPreferences key to track if tutorial has been shown
  static const String _tutorialShownKey = 'add_stoppage_tutorial_shown';

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
        mapKey,
        searchInputsKey,
        routeInfoKey,
        suggestionsKey,
        confirmButtonKey,
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
      title: 'Add Stoppage',
      description:
          'Use this screen to add an additional stop to your trip. You can add multiple destinations before reaching your final location.',
      tooltipBackgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for map
  static Widget buildMapShowcase({required Widget child}) {
    return Showcase(
      key: mapKey,
      title: 'Route Visualization',
      description:
          'This map shows your current location, pickup point, and destination. The blue line indicates the route that will be taken.',
      tooltipBackgroundColor: Colors.teal.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for search inputs
  static Widget buildSearchInputsShowcase({required Widget child}) {
    return Showcase(
      key: searchInputsKey,
      title: 'Location Search',
      description:
          'Enter your pickup and destination addresses here. The \'From\' field shows your starting point, and \'To\' is where you want to go.',
      tooltipBackgroundColor: Colors.purple.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12.px),
      child: child,
    );
  }

  /// Build showcase wrapper for route info
  static Widget buildRouteInfoShowcase({required Widget child}) {
    return Showcase(
      key: routeInfoKey,
      title: 'Trip Information',
      description:
          'This shows the calculated distance and estimated travel time for your route. Use this to plan your trip accordingly.',
      tooltipBackgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for suggestions
  static Widget buildSuggestionsShowcase({required Widget child}) {
    return Showcase(
      key: suggestionsKey,
      title: 'Location Suggestions',
      description:
          'As you type, relevant location suggestions will appear here. Tap on any suggestion to quickly select that location.',
      tooltipBackgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(8.px),
      child: child,
    );
  }

  /// Build showcase wrapper for confirm button
  static Widget buildConfirmButtonShowcase({required Widget child}) {
    return Showcase(
      key: confirmButtonKey,
      title: 'Confirm Stoppage',
      description:
          'Once you\'ve selected your stoppage location, tap this button to add it to your trip and proceed with booking.',
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
