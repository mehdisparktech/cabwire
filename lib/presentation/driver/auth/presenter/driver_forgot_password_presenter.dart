// ignore_for_file: invalid_use_of_protected_member

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/driver/driver_reset_password_usecase.dart';
import 'package:cabwire/domain/usecases/driver/forget_password_usecase.dart';
import 'package:cabwire/domain/usecases/driver/resent_code_usecase.dart';
import 'package:cabwire/domain/usecases/driver/verify_email_usecase.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_email_verification_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_forgot_password_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/presenter/utils/driver_sign_up_constants.dart';
import 'package:cabwire/presentation/driver/auth/presenter/utils/driver_sign_up_validation.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_confirm_information_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_email_verify_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverForgotPasswordPresenter
    extends BasePresenter<DriverForgotPasswordUiState>
    implements DriverEmailVerificationPresenter {
  final ForgetPasswordUsecase _forgetPasswordUsecase;

  final VerifyEmailUsecase _verifyEmailUsecase;
  final ResentCodeUsecase _resentCodeUsecase;
  final DriverResetPasswordUsecase _resetPasswordUsecase;
  DriverForgotPasswordPresenter(
    this._forgetPasswordUsecase,
    this._verifyEmailUsecase,
    this._resentCodeUsecase,
    this._resetPasswordUsecase,
  ) {
    _validation = DriverSignUpValidation();
  }

  final Obs<DriverForgotPasswordUiState> uiState = Obs(
    DriverForgotPasswordUiState.empty(),
  );
  DriverForgotPasswordUiState get currentUiState => uiState.value;

  // Validation helper
  late final DriverSignUpValidation _validation;

  // Email Controller
  @override
  final TextEditingController emailController = TextEditingController();

  // Verification Code Controllers & Focus Nodes
  @override
  final List<TextEditingController> verificationCodeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  @override
  final List<FocusNode> verificationCodeFocusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  // Form keys - create them lazily to avoid state lifecycle issues
  late final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>(
    debugLabel: 'resetPasswordForm_${identityHashCode(this)}',
  );
  late final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>(
    debugLabel: 'forgotPasswordForm_${identityHashCode(this)}',
  );

  // Reset Password Controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
  }

  @override
  String getMaskedEmail(String email) {
    final atIdx = email.indexOf('@');
    if (atIdx <= 1) return email;
    final visible = email.substring(0, 2);
    return '$visible***${email.substring(atIdx)}';
  }

  @override
  void onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      verificationCodeFocusNodes[index + 1].requestFocus();
    }
  }

  @override
  Future<void> verifyEmailCode(BuildContext context, bool isSignUp) async {
    final code =
        verificationCodeControllers.map((controller) => controller.text).join();
    debugPrint('code: $code');

    if (code.length != DriverSignUpConstants.verificationCodeLength) {
      await addUserMessage(
        'Please enter a valid ${DriverSignUpConstants.verificationCodeLength}-digit code',
      );
      return;
    }

    final result = await _verifyEmailUsecase.execute(
      emailController.text.trim(),
      code,
    );
    debugPrint('result: $result');
    result.fold((errorMessage) async => await addUserMessage(errorMessage), (
      data,
    ) async {
      debugPrint('Verification response data: $data');
      await addUserMessage(data['message']);
      final token = data['data'] as String;
      debugPrint('Token to be saved: $token');
      uiState.value = currentUiState.copyWith(resetToken: token);
      debugPrint('Updated state token: ${uiState.value.resetToken}');
    });

    if (result.isRight()) {
      debugPrint('result: ${result.fold((l) => l, (r) => r)}');
      final targetScreen =
          isSignUp
              ? const ConfirmInformationScreen()
              : const ResetPasswordScreen();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      }
      logError('resetToken: ${currentUiState.resetToken}');
    }
    await showMessage(message: result.fold((l) => l, (r) => r['message']));
  }

  @override
  Future<void> resendVerificationCode() async {
    final result = await _resentCodeUsecase.execute(
      emailController.text.trim(),
    );
    result.fold(
      (errorMessage) async {
        await addUserMessage(errorMessage);
        await showMessage(message: errorMessage);
      },
      (message) async {
        await addUserMessage(message);
        await showMessage(message: message);
      },
    );
    await showMessage(message: result.fold((l) => l, (r) => r));
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (!_validation.validateForm(forgotPasswordFormKey)) return;
    final result = await _forgetPasswordUsecase.execute(
      emailController.text.trim(),
    );
    result.fold(
      (errorMessage) async {
        await addUserMessage(errorMessage);
        await showMessage(message: errorMessage);
      },
      (message) async {
        await addUserMessage(message);
        await showMessage(message: message);
      },
    );
    if (result.isRight()) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (context) => DriverEmailVerificationScreen(isSignUp: false),
          ),
          (route) => true,
        );
      }
    }
    await showMessage(message: result.fold((l) => l, (r) => r));
  }

  // reset password

  Future<void> resetPassword(BuildContext context) async {
    if (!_validation.validateForm(resetPasswordFormKey)) return;
    final result = await _resetPasswordUsecase.execute(
      currentUiState.resetToken ?? '',
      passwordController.text,
      confirmPasswordController.text,
    );
    result.fold(
      (errorMessage) async => await addUserMessage(errorMessage),
      (message) async => await addUserMessage(message),
    );
    if (result.isRight()) {
      // Clear data before navigation
      clearControllers();

      // Ensure we're not in a bad state before navigating
      if (context.mounted) {
        // Use a microtask to ensure we're not in the middle of a build
        Future.microtask(() {
          // Pop all routes and push AuthNavigator
          Get.offAll(
            () => const DriverAuthNavigatorScreen(),
            predicate: (_) => false,
            duration: const Duration(milliseconds: 0), // Instant transition
          );
        });
      }
    }
    await showMessage(message: result.fold((l) => l, (r) => r));
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    currentUiState.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    // Dispose controllers first
    emailController.dispose();
    for (final c in verificationCodeControllers) {
      c.dispose();
    }
    for (final f in verificationCodeFocusNodes) {
      f.dispose();
    }
    passwordController.dispose();
    confirmPasswordController.dispose();

    // Clear form state if it exists
    if (resetPasswordFormKey.currentState != null) {
      resetPasswordFormKey.currentState?.deactivate();
    }
    if (forgotPasswordFormKey.currentState != null) {
      forgotPasswordFormKey.currentState?.deactivate();
    }

    super.dispose();
  }

  void clearControllers() {
    emailController.clear();
    for (final c in verificationCodeControllers) {
      c.clear();
    }
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
