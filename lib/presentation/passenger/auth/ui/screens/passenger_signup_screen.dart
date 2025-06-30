import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/toggle_auth_option.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';
import 'passenger_email_verify_screen.dart';

class PassengerSignUpScreen extends StatefulWidget {
  final VoidCallback toggleView;

  const PassengerSignUpScreen({super.key, required this.toggleView});

  @override
  State<PassengerSignUpScreen> createState() => _PassengerSignUpScreenState();
}

class _PassengerSignUpScreenState extends State<PassengerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _signUp() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign up logic here
    //   print('Name: ${_nameController.text}');
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(
      () => EmailVerificationScreen(
        email: 'example@email.com',
        onResendCode: () {},
        onVerify: (code) {},
        isSignUp: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Sign Up",
      subtitle: "Please Register To Login.",
      textColor: Colors.white,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icPassengerLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _nameController,
            hintText: 'Enter Full Name Here',
            validator: AuthValidators.validateName,
          ),
          gapH10,
          CustomTextFormField(
            controller: _emailController,
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
          gapH10,
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            isPassword: true,
            obscureTextValue: _obscurePassword,
            onVisibilityToggle: _togglePasswordVisibility,
            validator: AuthValidators.validatePassword,
          ),
          gapH10,
          CustomTextFormField(
            controller: _confirmPasswordController,
            hintText: 'Confirm Password',
            isPassword: true,
            obscureTextValue: _obscureConfirmPassword,
            onVisibilityToggle: _toggleConfirmPasswordVisibility,
            validator:
                (value) => AuthValidators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
          ),
        ],
        actionButton: CustomButton(text: "Sign Up", onPressed: _signUp),
        bottomWidgets: [
          ToggleAuthOption(
            leadingText: "All Ready Sign Up?",
            actionText: "Sign In",
            onActionPressed: widget.toggleView,
          ),
        ],
      ),
    );
  }
}
