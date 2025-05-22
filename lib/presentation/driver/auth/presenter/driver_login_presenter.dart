import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/home/ui/driver_home_page_offline.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_ui_state.dart';

class DriverLoginPresenter extends BasePresenter<DriverLoginUiState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Obs<DriverLoginUiState> uiState = Obs(DriverLoginUiState.empty());
  DriverLoginUiState get currentUiState => uiState.value;

  DriverLoginPresenter() {
    // For development purposes only - should be removed in production
    _initDevelopmentCredentials();
  }

  void _initDevelopmentCredentials() {
    emailController.text = 'mehdi@gmail.com';
    passwordController.text = '12345678';
  }

  void togglePasswordVisibility() {
    uiState.value = currentUiState.copyWith(
      obscurePassword: !currentUiState.obscurePassword,
    );
  }

  Future<void> onSignIn(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await toggleLoading(loading: true);

      try {
        // Simulate login logic - this should be replaced with real authentication
        await Future.delayed(const Duration(seconds: 1));

        if (context.mounted) {
          NavigationUtility.fadeReplacement(context, DriverHomePageOffline());
        }
      } finally {
        await toggleLoading(loading: false);
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
