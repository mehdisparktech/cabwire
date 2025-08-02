import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_confirm_information_ui_state.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_set_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerConfirmInformationPresenter
    extends BasePresenter<PassengerConfirmInformationUiState> {
  final ApiService apiService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final Obs<PassengerConfirmInformationUiState> uiState = Obs(
    PassengerConfirmInformationUiState.empty(),
  );
  PassengerConfirmInformationUiState get currentUiState => uiState.value;

  PassengerConfirmInformationPresenter(this.apiService);

  Future<void> confirmInformation(String email) async {
    if (formKey.currentState?.validate() ?? false) {
      appLog(
        'Confirming information: Name: ${nameController.text}, Phone: ${phoneNumberController.text}',
      );

      final response = await apiService.patch(
        ApiEndPoint.updatePassengerProfile + email,
        body: {
          'name': nameController.text,
          'contact': phoneNumberController.text,
        },
      );

      if (response.isRight()) {
        // Navigate to the next screen
        Get.to(() => SetLocationScreen(email: email));
      } else {
        addUserMessage("Something went wrong");
      }

      // Update UI state with the entered information
      uiState.value = currentUiState.copyWith(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
      );
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
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
