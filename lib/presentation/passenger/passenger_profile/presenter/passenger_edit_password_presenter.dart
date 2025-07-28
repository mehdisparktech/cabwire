import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/passenger/reset_password_usecase.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_edit_password_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerEditPasswordPresenter
    extends BasePresenter<PassengerEditPasswordUiState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  final Obs<PassengerEditPasswordUiState> uiState =
      Obs<PassengerEditPasswordUiState>(PassengerEditPasswordUiState.empty());

  PassengerEditPasswordUiState get currentUiState => uiState.value;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  PassengerEditPasswordPresenter(this._resetPasswordUseCase);

  Future<void> savePassword() async {
    if (newPasswordController.text != confirmNewPasswordController.text) {
      addUserMessage("New passwords do not match.");
      return;
    }
    if (newPasswordController.text.length < 6) {
      addUserMessage("New password must be at least 6 characters.");
      return;
    }

    toggleLoading(loading: true);

    final params = ResetPasswordParams(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmNewPasswordController.text,
    );

    appLog(
      "Changing password. Old: ${currentPasswordController.text}, New: ${newPasswordController.text}",
    );

    final result = await _resetPasswordUseCase.execute(params);

    result.fold(
      (error) {
        toggleLoading(loading: false);
        addUserMessage(error);
      },
      (_) {
        toggleLoading(loading: false);
        addUserMessage("Password changed successfully!");
        showMessage(message: uiState.value.userMessage);
        Get.back();
      },
    );
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
