import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_stripe_accoount_connect_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/presenter/utils/driver_sign_up_navigation.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:flutter/material.dart';

class DriverStripeAccoountConnectPresenter
    extends BasePresenter<DriverStripeAccoountConnectUiState> {
  late final DriverSignUpNavigation _navigation;

  final Obs<DriverStripeAccoountConnectUiState> uiState = Obs(
    DriverStripeAccoountConnectUiState.empty(),
  );
  DriverStripeAccoountConnectUiState get currentUiState => uiState.value;

  onStripeAccountConnect(BuildContext context) {
    if (context.mounted) {
      _navigation.navigateWithFadeTransition(
        context,
        const DriverAuthNavigatorScreen(),
        clearStack: true,
      );
    }
  }

  @override
  Future<void> addUserMessage(String message) {
    throw UnimplementedError();
  }

  @override
  Future<void> toggleLoading({required bool loading}) {
    throw UnimplementedError();
  }
}
