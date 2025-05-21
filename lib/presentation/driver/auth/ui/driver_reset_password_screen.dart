import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  // final _formKey = GlobalKey<FormState>(debugLabel: 'resetPasswordFormKey');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController =
      TextEditingController()..text = '12345678';
  final TextEditingController _confirmPasswordController =
      TextEditingController()..text = '12345678';
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

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      key: UniqueKey(),
      title: "Reset Password",
      subtitle: "Please enter your new password.",
      textColor: context.color.blackColor100,
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
          onPressed: () {
            Get.off(() => DriverLoginScreen(toggleView: () {}));
          },
        ),
      ),
    );
  }
}
