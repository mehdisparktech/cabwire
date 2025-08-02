import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/usecases/passenger/verify_email_usecase.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_email_verify_ui_state.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_auth_navigator_screen.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_confirm_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerEmailVerifyPresenter
    extends BasePresenter<PassengerEmailVerifyUiState> {
  final VerifyEmailUseCase _verifyEmailUseCase;
  final List<TextEditingController> codeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> codeFocusNodes = List.generate(4, (_) => FocusNode());

  final Obs<PassengerEmailVerifyUiState> uiState = Obs(
    PassengerEmailVerifyUiState.empty(),
  );

  PassengerEmailVerifyPresenter(this._verifyEmailUseCase);

  PassengerEmailVerifyUiState get currentUiState => uiState.value;

  String get maskedEmail {
    final email = uiState.value.email;
    if (email.isEmpty || !email.contains('@')) return email;

    final atIndex = email.indexOf('@');
    if (atIndex <= 3) {
      // If email username part is too short, just mask after first character
      return email.replaceRange(1, atIndex, '...');
    } else {
      // Otherwise mask from position 3 to @ symbol
      return email.replaceRange(3, atIndex, '...');
    }
  }

  void onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      codeFocusNodes[index + 1].requestFocus();
    }
  }

  Future<void> verifyCode() async {
    await toggleLoading(loading: true);

    String code = codeControllers.map((controller) => controller.text).join();
    appLog("Verification code: $code", source: "PassengerEmailVerifyPresenter");

    // Here you would typically call a use case to verify the code
    // For now, we'll simulate success and navigate based on isSignUp

    // Simulating API call delay
    final result = await _verifyEmailUseCase.execute(
      VerifyEmailParams(
        email: uiState.value.email,
        oneTimeCode: int.tryParse(code) ?? 0,
      ),
    );

    result.fold(
      (error) {
        addUserMessage(error);
      },
      (entity) {
        uiState.value = uiState.value.copyWith(
          isLoading: false,
          userMessage: entity.message,
        );
        if (uiState.value.isSignUp) {
          Get.to(() => ConfirmInformationScreen(email: uiState.value.email));
        } else {
          Get.to(() => PassengerAuthNavigationScreen());
        }
      },
    );
  }

  Future<void> resendCode() async {
    await toggleLoading(loading: true);
    appLog(
      "Resending code to ${uiState.value.email}",
      source: "PassengerEmailVerifyPresenter",
    );

    // Here you would typically call a use case to resend the verification code

    // Simulating API call delay
    await Future.delayed(const Duration(seconds: 1));

    uiState.value = uiState.value.copyWith(
      isLoading: false,
      userMessage: "Verification code resent successfully",
    );
  }

  @override
  void dispose() {
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var focusNode in codeFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = uiState.value.copyWith(isLoading: loading);
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = uiState.value.copyWith(userMessage: message);
  }
}
