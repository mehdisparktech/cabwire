import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../common/components/auth/custom_text_form_field.dart';
import '../../../../common/components/auth/custom_button.dart';
import '../../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../../common/components/auth/auth_form_container.dart';
import '../../../../common/components/auth/auth_validators.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/core/di/service_locator.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<DriverSignUpPresenter>();
    return AuthScreenWrapper(
      title: AppStrings.driverForgotPassword,
      subtitle: AppStrings.driverEnterEmailHint,
      textColor: Colors.black,
      child: AuthFormContainer(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.resetPasswordFormKey,
        formFields: [
          CustomTextFormField(
            controller: presenter.emailController,
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
        ],
        actionButton: CustomButton(
          text: AppStrings.driverGetVerificationCode,
          onPressed: () => presenter.forgotPassword(context),
        ),
      ),
    );
  }
}
