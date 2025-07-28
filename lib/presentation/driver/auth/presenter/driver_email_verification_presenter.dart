import 'package:flutter/material.dart';

abstract class DriverEmailVerificationPresenter {
  TextEditingController get emailController;
  List<TextEditingController> get verificationCodeControllers;
  List<FocusNode> get verificationCodeFocusNodes;

  String getMaskedEmail(String email);
  void onCodeDigitInput(int index, String value);
  void resendVerificationCode();
  void verifyEmailCode(BuildContext context, bool isSignUp);
}
