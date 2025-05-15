import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/toggle_auth_option.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';
import '../../../../core/static/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleView;

  const LoginScreen({super.key, required this.toggleView});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _signIn() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Sign In",
      subtitle: "Welcome Back To Cabwire.",
      textColor: Colors.black,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _emailController,
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
          gapH20,
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            isPassword: true,
            obscureTextValue: _obscurePassword,
            onVisibilityToggle: _togglePasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          gapH10,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Forgot password logic
                Get.to(() => ForgotPasswordScreen());
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                  color: AppColors.textBlack87,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
        actionButton: CustomButton(text: "Sign In", onPressed: _signIn),
        bottomWidgets: [
          ToggleAuthOption(
            leadingText: "Don't Have an Account?",
            actionText: "Sign Up",
            onActionPressed: widget.toggleView,
          ),
        ],
      ),
    );
  }
}
