import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_forgot_password_presenter.dart';
import 'package:flutter/material.dart';
import '../../../../common/components/auth/custom_text_form_field.dart';
import '../../../../common/components/auth/custom_button.dart';
import '../../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../../common/components/auth/auth_form_container.dart';
import '../../../../common/components/auth/auth_validators.dart';

/// Reset password screen for drivers
///
/// Used after email verification in the forgot password flow
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final presenter = locate<DriverForgotPasswordPresenter>();

    return AuthScreenWrapper(
      title: AppStrings.driverResetPassword,
      subtitle: AppStrings.driverEnterNewPassword,
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.resetPasswordFormKey,
        formFields: [
          CustomTextFormField(
            controller: presenter.passwordController,
            hintText: AppStrings.driverNewPassword,
            isPassword: true,
            obscureTextValue: presenter.obscurePassword,
            onVisibilityToggle: () => presenter.togglePasswordVisibility(),
            validator: AuthValidators.validatePassword,
          ),
          gapH20,
          CustomTextFormField(
            controller: presenter.confirmPasswordController,
            hintText: AppStrings.driverConfirmNewPassword,
            isPassword: true,
            obscureTextValue: presenter.obscureConfirmPassword,
            onVisibilityToggle:
                () => presenter.toggleConfirmPasswordVisibility(),
            validator:
                (value) => AuthValidators.validateConfirmPassword(
                  value,
                  presenter.passwordController.text,
                ),
          ),
        ],
        actionButton: CustomButton(
          text: AppStrings.driverResetPassword,
          onPressed: () => presenter.resetPassword(context),
        ),
      ),
    );
  }
}
