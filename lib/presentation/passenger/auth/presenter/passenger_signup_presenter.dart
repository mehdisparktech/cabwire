import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/enum/user_type.dart';
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

  Future<void> signupPassenger() async {
    await toggleLoading(loading: true);

    if (formKey.currentState?.validate() ?? false) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      return;
    }

    final params = CreatePassengerParams(
      name: nameController.text,
      role: UserType.passenger.name,
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
        );
        Get.to(
          () => EmailVerificationScreen(
            email: emailController.text,
            onResendCode: () {},
            onVerify: (code) {},
            isSignUp: true,
          ),
        );
      },
    );
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
