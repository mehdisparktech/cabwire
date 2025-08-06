import 'package:cabwire/core/config/themes.dart';
import 'package:cabwire/core/enum/user_type.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/driver_home_page_offline.dart';
import 'package:cabwire/presentation/driver/main/ui/screens/driver_main_page.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_ui_state.dart';
import 'package:cabwire/domain/usecases/driver/sign_in_usecase.dart';
import 'package:get/get.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';

class DriverLoginPresenter extends BasePresenter<DriverLoginUiState> {
  final SignInUsecase _signInUsecase;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Obs<DriverLoginUiState> uiState = Obs(DriverLoginUiState.empty());
  DriverLoginUiState get currentUiState => uiState.value;

  // final LoginUseCase _loginUseCase;
  DriverLoginPresenter(this._signInUsecase);

  @override
  void onInit() {
    super.onInit();
    _initDevelopmentCredentials();
    _checkExistingLogin();
  }

  void _initDevelopmentCredentials() {
    emailController.text = 'fohoya4555@balincs.com';
    passwordController.text = '123456789';
  }

  Future<void> _checkExistingLogin() async {
    await LocalStorage.getAllPrefData();

    if (LocalStorage.isLogIn && !LocalStorage.isTokenExpired()) {
      // Valid token exists, navigate to home
      Get.offAll(() => DriverMainPage());
    }
  }

  void togglePasswordVisibility() {
    uiState.value = currentUiState.copyWith(
      obscurePassword: !currentUiState.obscurePassword,
    );
  }

  Future<void> onSignIn(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await executeTaskWithLoading(() async {
        appLog('Attempting sign in...'); // Debug print
        final result = await _signInUsecase.execute(
          emailController.text.trim(),
          passwordController.text,
        );

        await result.fold(
          // Handle error
          (errorMessage) async {
            appLog('Sign in error: $errorMessage'); // Debug print
            await addUserMessage(errorMessage);
            showMessage(message: errorMessage);
          },
          // Handle success
          (user) async {
            appLog('Sign in successful, updating UI state...'); // Debug print

            // Save token and user data
            if (user.data?.token != null) {
              await LocalStorage.saveLoginData(
                user.data!.token!,
                UserType.driver,
                AppTheme.driverTheme,
              );
            }

            uiState.value = currentUiState.copyWith(
              user: user,
              isAuthenticated: true,
            );

            appLog('Attempting navigation...'); // Debug print
            clearControllers();
            Get.offAll(() => DriverHomePageOffline());
            appLog('Navigation called'); // Debug print
          },
        );
      });
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

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
