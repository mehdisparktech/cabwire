import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/home/ui/driver_home_page_offline.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_ui_state.dart';

class DriverLoginPresenter extends BasePresenter<DriverLoginUiState> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController()..text = 'mehdi@gmail.com';
  final passwordController = TextEditingController()..text = '12345678';

  final Obs<DriverLoginUiState> uiState = Obs(DriverLoginUiState.empty());

  DriverLoginUiState get currentUiState => uiState.value;

  void togglePasswordVisibility() {
    uiState.value = currentUiState.copyWith(
      obscurePassword: !currentUiState.obscurePassword,
    );
  }

  Future<void> onSignIn(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await toggleLoading(loading: true);

      // Simulate login logic
      await Future.delayed(const Duration(seconds: 1));

      await toggleLoading(loading: false);
      if (context.mounted) {
        NavigationUtility.fadeReplacement(context, DriverHomePageOffline());
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
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
