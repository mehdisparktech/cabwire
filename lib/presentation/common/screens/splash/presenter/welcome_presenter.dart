import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/themes.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/common/screens/splash/presenter/welcome_ui_state.dart';
import 'package:cabwire/presentation/driver/onboarding/ui/screens/driver_onboarding_screen.dart';
import 'package:cabwire/presentation/passenger/onboarding/ui/screens/passenger_onboarding_screen.dart';
import 'package:flutter/material.dart';

class WelcomePresenter extends BasePresenter<WelcomeUiState> {
  final Obs<WelcomeUiState> uiState = Obs(WelcomeUiState.empty());

  WelcomeUiState get currentUiState => uiState.value;

  WelcomePresenter();

  void onPassengerButtonPressed(BuildContext context) {
    uiState.value = currentUiState.copyWith(userType: UserType.passenger);
    uiState.value = currentUiState.copyWith(theme: AppTheme.passengerTheme);

    NavigationUtility.fadePush(context, PassengerOnboardingScreen());
  }

  void onDriverButtonPressed(BuildContext context) {
    uiState.value = currentUiState.copyWith(userType: UserType.driver);
    uiState.value = currentUiState.copyWith(theme: AppTheme.driverTheme);

    NavigationUtility.fadePush(context, DriverOnboardingScreen());
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
