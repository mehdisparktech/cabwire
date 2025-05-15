import 'package:cabwire/presentation/passenger/auth/ui/email_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_screen_wrapper.dart';
import '../widgets/auth_form_container.dart';
import '../widgets/auth_validators.dart';

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
        email: 'example@email.com',
        onResendCode: () {},
        onVerify: (code) {},
        isSignUp: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Forgot Password",
      subtitle: "Please enter your email to continue.",
      child: AuthFormContainer(
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
