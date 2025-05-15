import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/auth/ui/email_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_header.dart';
import '../widgets/app_logo_display.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(
      () => EmailVerificationScreen(
        email: 'example@email.com',
        onResendCode: () {},
        onVerify: (code) {},
        isSignUp: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                title: "Forgot Password",
                subtitle: "Please enter your email to continue.",
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLogoDisplay(
                            logoAssetPath: AppAssets.icPassengerLogo,
                            logoAssetPath2: AppAssets.icCabwireLogo,
                            appName: 'cabwire',
                            color: context.color.primaryBtn,
                          ),
                          gapH30,
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: 'Enter Your Name',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          gapH20,
                          CustomButton(
                            text: "Get Verification Code",
                            onPressed: _signIn,
                          ),
                        ],
                      ),
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
