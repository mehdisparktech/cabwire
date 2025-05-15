import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_header.dart';
import '../widgets/app_logo_display.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/toggle_auth_option.dart';
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
    if (_formKey.currentState?.validate() ?? false) {
      // Sign in logic here
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryGradient,
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
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: "Sign In",
                subtitle: "Welcome Back To Cabwire.",
                color: context.color.whiteColor,
              ),
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
                            hintText: 'example@email.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
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
                              },
                              style: TextButton.styleFrom(
                                // Overriding theme for this specific TextButton as per original
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: AppColors.textBlack87,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .normal, // Original had default weight
                                ),
                              ),
                            ),
                          ),
                          gapH20,
                          CustomButton(text: "Sign In", onPressed: _signIn),
                          gapH30,
                          ToggleAuthOption(
                            leadingText: "Don't Have an Account?",
                            actionText: "Sign Up",
                            onActionPressed: widget.toggleView,
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
