import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/themes.dart';
import 'package:cabwire/core/enum/user_type.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/usecases/determine_first_run_use_case.dart';
import 'package:cabwire/presentation/common/screens/splash/presenter/welcome_ui_state.dart';
import 'package:cabwire/presentation/driver/onboarding/ui/screens/driver_onboarding_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_auth_navigator_screen.dart';
import 'package:cabwire/presentation/passenger/onboarding/ui/screens/passenger_onboarding_screen.dart';
import 'package:flutter/material.dart';

class WelcomePresenter extends BasePresenter<WelcomeUiState> {
  final DetermineFirstRunUseCase _determineFirstRunUseCase;
  final Obs<WelcomeUiState> uiState = Obs(WelcomeUiState.empty());

  WelcomeUiState get currentUiState => uiState.value;

  WelcomePresenter(this._determineFirstRunUseCase);

  @override
  void onInit() {
    super.onInit();
    checkTheme();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final isFirstTime = await _determineFirstRunUseCase.execute();
    uiState.value = currentUiState.copyWith(isFirstRun: isFirstTime);
  }

  Future<void> onFirstRunPressed(BuildContext context) async {
    final isFirstTime = await _determineFirstRunUseCase.execute();
    uiState.value = currentUiState.copyWith(isFirstRun: isFirstTime);
  }

  void onPassengerButtonPressed(BuildContext context) {
    uiState.value = currentUiState.copyWith(userType: UserType.passenger);
    uiState.value = currentUiState.copyWith(theme: AppTheme.passengerTheme);

    NavigationUtility.fadePush(
      context,
      uiState.value.isFirstRun
          ? PassengerOnboardingScreen()
          : PassengerAuthNavigationScreen(),
    );
  }

  void onDriverButtonPressed(BuildContext context) {
    uiState.value = currentUiState.copyWith(userType: UserType.driver);
    uiState.value = currentUiState.copyWith(theme: AppTheme.driverTheme);

    NavigationUtility.fadePush(
      context,
      uiState.value.isFirstRun
          ? DriverOnboardingScreen()
          : DriverAuthNavigatorScreen(),
    );
  }

  void onThemeChanged(ThemeData theme) {
    uiState.value = currentUiState.copyWith(theme: theme);
  }

  Future<void> checkTheme() async {
    await LocalStorage.getAllPrefData();
    if (LocalStorage.isLogIn && !LocalStorage.isTokenExpired()) {
      uiState.value = currentUiState.copyWith(theme: LocalStorage.theme);
    } else {
      uiState.value = currentUiState.copyWith(theme: AppTheme.lightTheme);
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
