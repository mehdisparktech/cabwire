import 'package:flutter/material.dart';

class NavigationUtility {
  /// Navigate to a new screen with a left-to-right slide animation
  ///
  /// Parameters:
  /// - context: BuildContext required for navigation
  /// - screen: The Widget/Screen to navigate to
  /// - duration: Optional duration for the animation (defaults to 300ms)
  ///
  /// Usage example:
  /// ```dart
  /// NavigationUtility.slideRight(context, HomeScreen());
  /// ```
  static void slideRight(
    BuildContext context,
    Widget screen, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Navigate to a new screen and replace the current one with a left-to-right slide animation
  ///
  /// Parameters:
  /// - context: BuildContext required for navigation
  /// - screen: The Widget/Screen to navigate to
  /// - duration: Optional duration for the animation (defaults to 300ms)
  ///
  /// Usage example:
  /// ```dart
  /// NavigationUtility.slideRightReplacement(context, HomeScreen());
  /// ```
  static void slideRightReplacement(
    BuildContext context,
    Widget screen, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static void fadePush(
    BuildContext context,
    Widget screen, {
    Duration duration = const Duration(milliseconds: 50),
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static void fadeReplacement(
    BuildContext context,
    Widget screen, {
    Duration duration = const Duration(milliseconds: 50),
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
