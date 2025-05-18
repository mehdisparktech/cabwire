import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_auth_navigator_screen.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
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

  void _resetPassword() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Reset password logic
    // }
    NavigationUtility.slideRight(context, AuthNavigator());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Reset Password",
      subtitle: "Please enter your new password.",
      textColor: Colors.black,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'New Password',
            isPassword: true,
            obscureTextValue: _obscurePassword,
            onVisibilityToggle: _togglePasswordVisibility,
            validator: AuthValidators.validatePassword,
          ),
          gapH20,
          CustomTextFormField(
            controller: _confirmPasswordController,
            hintText: 'Confirm New Password',
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
        actionButton: CustomButton(
          text: "Reset Password",
          onPressed: _resetPassword,
        ),
      ),
    );
  }
}
