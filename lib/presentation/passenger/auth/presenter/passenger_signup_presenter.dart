import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/external_libs/flutter_toast/toast_utility.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/usecases/passenger/create_passenger_usecase.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_signup_ui_state.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_email_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerSignupPresenter extends BasePresenter<PassengerSignupUiState> {
  final CreatePassengerUseCase _createPassengerUseCase;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final Obs<PassengerSignupUiState> uiState = Obs(
    PassengerSignupUiState.empty(),
  );

  PassengerSignupPresenter(this._createPassengerUseCase);

  PassengerSignupUiState get currentUiState => uiState.value;

  void togglePasswordVisibility() {
    uiState.value = uiState.value.copyWith(
      obscurePassword: !uiState.value.obscurePassword,
    );
  }

  void toggleConfirmPasswordVisibility() {
    uiState.value = uiState.value.copyWith(
      obscureConfirmPassword: !uiState.value.obscureConfirmPassword,
    );
  }

  Future<void> signupPassenger(BuildContext context) async {
    await toggleLoading(loading: true);
    appLog("Sign Up Button Pressed", source: "PassengerSignupPresenter");
    appLog(
      "loading: ${uiState.value.isLoading}",
      source: "PassengerSignupPresenter",
    );
    appLog(
      "Form Key: ${formKey.currentState?.validate()}",
      source: "PassengerSignupPresenter",
    );
    appLog("Name: ${nameController.text}", source: "PassengerSignupPresenter");
    appLog(
      "Email: ${emailController.text}",
      source: "PassengerSignupPresenter",
    );
    appLog(
      "Password: ${passwordController.text}",
      source: "PassengerSignupPresenter",
    );
    appLog(
      "Confirm Password: ${confirmPasswordController.text}",
      source: "PassengerSignupPresenter",
    );

    if (formKey.currentState?.validate() ?? false) {
      final params = CreatePassengerParams(
        name: nameController.text,
        role: "USER",
        email: emailController.text,
        password: passwordController.text,
      );

      final result = await _createPassengerUseCase.execute(params);

      result.fold(
        (error) {
          uiState.value = uiState.value.copyWith(
            isLoading: false,
            userMessage: error,
          );
        },
        (_) {
          uiState.value = uiState.value.copyWith(
            isLoading: false,
            isSuccess: true,
            userMessage: "sent verification code to your email",
          );
          Get.to(
            () => EmailVerificationScreen(
              email: emailController.text,
              isSignUp: true,
            ),
          );
        },
      );
      ToastUtility.showCustomToast(message: uiState.value.userMessage ?? "");
    }

    if (passwordController.text != confirmPasswordController.text) {
      uiState.value = uiState.value.copyWith(
        isLoading: false,
        userMessage: "Password and Confirm Password do not match",
      );
      return;
    }

    if (nameController.text.isEmpty) {
      uiState.value = uiState.value.copyWith(
        isLoading: false,
        userMessage: "Please enter your name",
      );
      return;
    }

    if (emailController.text.isEmpty) {
      uiState.value = uiState.value.copyWith(
        isLoading: false,
        userMessage: "Please enter your email",
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      uiState.value = uiState.value.copyWith(
        isLoading: false,
        userMessage: "Please enter your password",
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      uiState.value = uiState.value.copyWith(
        isLoading: false,
        userMessage: "Please enter your confirm password",
      );
      return;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
