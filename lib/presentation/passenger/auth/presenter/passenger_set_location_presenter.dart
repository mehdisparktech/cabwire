import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_set_location_ui_state.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_auth_navigator_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerSetLocationPresenter
    extends BasePresenter<PassengerSetLocationUiState> {
  final ApiService apiService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();

  final Obs<PassengerSetLocationUiState> uiState = Obs(
    PassengerSetLocationUiState.empty(),
  );
  PassengerSetLocationUiState get currentUiState => uiState.value;

  PassengerSetLocationPresenter(this.apiService);

  Future<void> setLocation(String email) async {
    if (formKey.currentState?.validate() ?? false) {
      appLog('Setting location: ${locationController.text}');

      final response = await apiService.patch(
        ApiEndPoint.updatePassengerProfile + email,
        body: {'location': locationController.text},
      );

      if (response.isRight()) {
        Get.to(() => PassengerAuthNavigationScreen());
      } else {
        addUserMessage("Something went wrong");
      }
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }
}
