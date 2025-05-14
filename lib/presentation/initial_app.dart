import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/splash/presenter/welcome_presenter.dart';
import 'package:cabwire/presentation/common/splash/presenter/welcome_ui_state.dart';
import 'package:cabwire/presentation/common/splash/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/config/themes.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class InitialApp extends StatelessWidget {
  InitialApp({super.key, required this.isFirstRun});

  final bool isFirstRun;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get globalContext =>
      navigatorKey.currentContext ?? Get.context!;
  final WelcomePresenter presenter = locate<WelcomePresenter>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
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
              theme:
                  presenter.currentUiState.userType == UserType.passenger
                      ? AppTheme.passengerTheme
                      : AppTheme.driverTheme,
              title: 'Cabwire',
              // home: isFirstRun ? OnboardingPage() : MainPage(),
              home: WelcomeScreen(),
            );
          },
        );
      },
    );
  }
}
