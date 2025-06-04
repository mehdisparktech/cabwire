import 'package:flutter/material.dart';

class DriverSignUpNavigation {
  // Navigation with slide transition
  void navigateWithSlideTransition(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => destination,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.push(context, route);
    }
  }

  // Navigation with fade transition
  void navigateWithFadeTransition(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => destination,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.push(context, route);
    }
  }

  // Navigation with scale transition
  void navigateWithScaleTransition(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => destination,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.push(context, route);
    }
  }

  // Navigation with custom transition
  void navigateWithCustomTransition(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => destination,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Combine slide and fade transitions
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.push(context, route);
    }
  }

  // Simple navigation without custom transitions
  void navigateToScreen(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    if (clearStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => destination),
        (route) => false,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }
  }

  // Navigate back
  void navigateBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Navigate back with result
  void navigateBackWithResult(BuildContext context, dynamic result) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }
}
