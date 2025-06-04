import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_ui_state.dart';

class DriverLoginPresenter extends BasePresenter<DriverLoginUiState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Obs<DriverLoginUiState> uiState = Obs(DriverLoginUiState.empty());
  DriverLoginUiState get currentUiState => uiState.value;

  // final LoginUseCase _loginUseCase;

  @override
  void onInit() {
    super.onInit();
    _initDevelopmentCredentials();
    _checkExistingLogin();
  }

  void _initDevelopmentCredentials() {
    emailController.text = 'mehdi@gmail.com';
    passwordController.text = '12345678';
  }

  Future<void> _checkExistingLogin() async {
    // This would check for existing login session using a usecase
    // For now, we'll leave it empty
  }

  void togglePasswordVisibility() {
    uiState.value = currentUiState.copyWith(
      obscurePassword: !currentUiState.obscurePassword,
    );
  }

  Future<void> onSignIn(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      // await executeTaskWithLoading(() async {
      //   final result = await _loginUseCase.execute(
      //     email: emailController.text.trim(),
      //     password: passwordController.text,
      //   );

      //   await result.fold(
      //     // Handle error
      //     (errorMessage) async {
      //       await addUserMessage(errorMessage);
      //     },
      //     // Handle success
      //     (user) async {
      //       uiState.value = currentUiState.copyWith(
      //         user: user,
      //         isAuthenticated: true,
      //       );

      //       if (context.mounted) {
      //         NavigationUtility.fadeReplacement(
      //           context,
      //           DriverHomePageOffline(),
      //         );
      //       }
      //     },
      //   );
      // });
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
