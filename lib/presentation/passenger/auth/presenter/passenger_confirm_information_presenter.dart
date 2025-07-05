import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_confirm_information_ui_state.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_set_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerConfirmInformationPresenter
    extends BasePresenter<PassengerConfirmInformationUiState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final Obs<PassengerConfirmInformationUiState> uiState = Obs(
    PassengerConfirmInformationUiState.empty(),
  );
  PassengerConfirmInformationUiState get currentUiState => uiState.value;

  PassengerConfirmInformationPresenter();

  @override
  void onInit() {
    super.onInit();
  }

  void confirmInformation() {
    if (formKey.currentState?.validate() ?? false) {
      appLog(
        'Confirming information: Name: ${nameController.text}, Phone: ${phoneNumberController.text}',
      );

      // Update UI state with the entered information
      uiState.value = currentUiState.copyWith(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
      );

      // Navigate to the next screen
      Get.to(() => const SetLocationScreen());
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
