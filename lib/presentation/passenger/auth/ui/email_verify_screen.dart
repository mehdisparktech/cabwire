import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/auth/ui/confirm_information_screen.dart';
import 'package:cabwire/presentation/passenger/auth/ui/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/app_logo_display.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback onResendCode;
  final Function(String) onVerify;
  final bool isSignUp;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.onResendCode,
    required this.onVerify,
    required this.isSignUp,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeVerify() {
    // String code = _controllers.map((controller) => controller.text).join();
    // if (code.length == 6) {
    //   widget.onVerify(code);
    // }
    if (widget.isSignUp) {
      Get.to(() => ConfirmInformationScreen());
    } else {
      Get.to(() => LoginScreen(toggleView: () {}));
    }
  }

  void _onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    String maskedEmail = widget.email.replaceRange(
      3,
      widget.email.indexOf('@'),
      '...',
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [
                AppColor.passengerPrimaryGradient,
                AppColor.passengerSecondaryGradient,
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              gapH30,
              AuthHeader(
                title: "Verify Email",
                subtitle: "Please enter the code sent to your email",
                color: context.color.whiteColor,
              ),
              gapH30,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.color.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        AppLogoDisplay(
                          logoAssetPath: AppAssets.icPassengerLogo,
                          logoAssetPath2: AppAssets.icCabwireLogo,
                          appName: 'cabwire',
                          color: context.color.primaryBtn,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          "We've Sent a Code to $maskedEmail",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            6,
                            (index) => SizedBox(
                              width: 40,
                              height: 50,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: context.color.primaryBtn,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged:
                                    (value) => _onCodeDigitInput(index, value),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "If you didn't receive a code: ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: widget.onResendCode,
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                  color: context.color.primaryBtn,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomButton(text: "Verify", onPressed: _onCodeVerify),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
