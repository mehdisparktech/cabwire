import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/driver/forget_password_usecase.dart';
import 'package:cabwire/domain/usecases/driver/resent_code_usecase.dart';
import 'package:cabwire/domain/usecases/driver/verify_email_usecase.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_email_verification_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_forgot_password_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/presenter/utils/driver_sign_up_constants.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_confirm_information_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_email_verify_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_reset_password_screen.dart';
import 'package:flutter/material.dart';

class DriverForgotPasswordPresenter
    extends BasePresenter<DriverForgotPasswordUiState>
    implements DriverEmailVerificationPresenter {
  final ForgetPasswordUsecase _forgetPasswordUsecase;

  final VerifyEmailUsecase _verifyEmailUsecase;
  final ResentCodeUsecase _resentCodeUsecase;
  DriverForgotPasswordPresenter(
    this._forgetPasswordUsecase,
    this._verifyEmailUsecase,
    this._resentCodeUsecase,
  );

  final Obs<DriverForgotPasswordUiState> uiState = Obs(
    DriverForgotPasswordUiState.empty(),
  );
  DriverForgotPasswordUiState get currentUiState => uiState.value;

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

  // Reset Password Controllers
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
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
    result.fold(
      (errorMessage) async => await addUserMessage(errorMessage),
      (message) async => await addUserMessage(message),
    );

    if (result.isRight()) {
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
    }
    await showMessage(message: result.fold((l) => l, (r) => r));
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DriverEmailVerificationScreen(isSignUp: false),
          ),
        );
      }
    }
    await showMessage(message: result.fold((l) => l, (r) => r));
  }

  @override
  Future<void> addUserMessage(String message) async {
    currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    currentUiState.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    for (final c in verificationCodeControllers) {
      c.dispose();
    }
    for (final f in verificationCodeFocusNodes) {
      f.dispose();
    }
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
