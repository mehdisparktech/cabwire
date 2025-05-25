import 'package:cabwire/presentation/driver/main/presenter/driver_main_presenter.dart';
import 'package:flutter/material.dart';

class DoubleTapBackToExitApp extends StatelessWidget {
  const DoubleTapBackToExitApp({
    required this.child,
    required this.mainPresenter,
    super.key,
  });

  final Widget child;
  final DriverMainPresenter mainPresenter;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await mainPresenter.handleBackPress();
      },
      child: child,
    );
  }
}
