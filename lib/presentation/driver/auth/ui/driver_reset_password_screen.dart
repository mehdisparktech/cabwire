import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';

/// Reset password screen for drivers
///
/// Used after email verification in the forgot password flow
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final presenter = locate<DriverSignUpPresenter>();

    return AuthScreenWrapper(
      title: "Reset Password",
      subtitle: "Please enter your new password.",
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.resetPasswordFormKey,
        formFields: [
          CustomTextFormField(
            controller: presenter.resetPasswordController,
            hintText: 'New Password',
            isPassword: true,
            obscureTextValue: presenter.resetObscurePassword,
            onVisibilityToggle: () => presenter.toggleResetPasswordVisibility(),
            validator: AuthValidators.validatePassword,
          ),
          gapH20,
          CustomTextFormField(
            controller: presenter.resetConfirmPasswordController,
            hintText: 'Confirm New Password',
            isPassword: true,
            obscureTextValue: presenter.resetObscureConfirmPassword,
            onVisibilityToggle:
                () => presenter.toggleResetConfirmPasswordVisibility(),
            validator:
                (value) => AuthValidators.validateConfirmPassword(
                  value,
                  presenter.resetPasswordController.text,
                ),
          ),
        ],
        actionButton: CustomButton(
          text: "Reset Password",
          onPressed: () => presenter.resetPassword(context),
        ),
      ),
    );
  }
}
