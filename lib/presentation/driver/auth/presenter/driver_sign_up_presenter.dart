import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_email_verify_screen.dart';
import 'package:flutter/material.dart';
import 'driver_sign_up_ui_state.dart';

class DriverSignUpPresenter extends BasePresenter<SignUpUiState> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final Obs<SignUpUiState> uiState = Obs(SignUpUiState.empty());

  SignUpUiState get state => uiState.value;

  void togglePasswordVisibility() {
    uiState.value = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    uiState.value = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  void onSignUp(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      toggleLoading(loading: true);

      // Simulate sign up success
      NavigationUtility.slideRight(
        context,
        EmailVerificationScreen(
          email: emailController.text,
          onResendCode: () {},
          onVerify: (code) {},
          isSignUp: true,
        ),
      );

      toggleLoading(loading: false);
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = state.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = state.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
