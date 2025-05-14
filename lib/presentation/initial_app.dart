import 'package:cabwire/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/config/themes.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class InitialApp extends StatelessWidget {
  const InitialApp({super.key, required this.isFirstRun});

  final bool isFirstRun;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get globalContext =>
      navigatorKey.currentContext ?? Get.context!;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return Overlay(
              initialEntries: [OverlayEntry(builder: (context) => child!)],
            );
          },
          onInit: () => AppScreen.setUp(context),
          onReady: () => AppScreen.setUp(context),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.passengerTheme,
          title: 'Initial Project',
          // home: isFirstRun ? OnboardingPage() : MainPage(),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
