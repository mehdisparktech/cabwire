import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/common/screens/splash/presenter/welcome_ui_state.dart';
import 'package:cabwire/presentation/driver/onboarding/ui/driver_onboarding_screen.dart';
import 'package:cabwire/presentation/passenger/onboarding/ui/passenger_onboarding_screen.dart';
import 'package:get/get.dart';

class WelcomePresenter extends BasePresenter<WelcomeUiState> {
  final Obs<WelcomeUiState> uiState = Obs(WelcomeUiState.empty());

  WelcomeUiState get currentUiState => uiState.value;

  WelcomePresenter();

  void onPassengerButtonPressed() {
    uiState.value = currentUiState.copyWith(userType: UserType.passenger);
    Get.to(() => PassengerOnboardingScreen());
  }

  void onDriverButtonPressed() {
    uiState.value = currentUiState.copyWith(userType: UserType.driver);
    Get.to(() => DriverOnboardingScreen());
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
