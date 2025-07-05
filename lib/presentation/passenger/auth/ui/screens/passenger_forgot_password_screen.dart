import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_email_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendVerificationCode() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    // }
    Get.to(
      () => EmailVerificationScreen(
        email: _emailController.text,
        isSignUp: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Forgot Password",
      subtitle: "Please enter your email to continue.",
      textColor: Colors.white,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icPassengerLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _emailController,
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
        ],
        actionButton: CustomButton(
          text: "Get Verification Code",
          onPressed: _sendVerificationCode,
        ),
      ),
    );
  }
}
