import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/app_colors.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_login_presenter.dart';
import 'package:cabwire/presentation/passenger/auth/ui/screens/passenger_forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/toggle_auth_option.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';

class PassengerLoginScreen extends StatelessWidget {
  final VoidCallback toggleView;

  const PassengerLoginScreen({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<PassengerLoginPresenter>();

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return AuthScreenWrapper(
          title: AppStrings.passengerSignIn,
          subtitle: AppStrings.passengerWelcomeBackToCabwire,
          textColor: Colors.white,
          child: AuthFormContainer(
            formKey: presenter.formKey,
            logoAssetPath: AppAssets.icPassengerLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formFields: [
              CustomTextFormField(
                controller: presenter.emailController,
                hintText: AppStrings.passengerEnterEmailHint,
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidators.validateEmail,
              ),
              gapH20,
              CustomTextFormField(
                controller: presenter.passwordController,
                hintText: AppStrings.passengerEnterPassword,
                isPassword: true,
                obscureTextValue: presenter.uiState.value.obscurePassword,
                onVisibilityToggle: presenter.togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.passengerEnterPassword;
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
                    textStyle: const TextStyle(
                      color: AppColors.textBlack87,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      inherit: true,
                    ),
                  ),
                  child: Text(
                    AppStrings.passengerForgotPassword,
                    style: TextStyle(
                      color: AppColors.textBlack87,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      inherit: true,
                    ),
                  ),
                ),
              ),
            ],
            actionButton: CustomButton(
              text: AppStrings.passengerSignIn,
              onPressed:
                  () =>
                      presenter.uiState.value.isLoading
                          ? null
                          : presenter.onSignIn(context),
              isLoading: presenter.uiState.value.isLoading,
            ),
            bottomWidgets: [
              ToggleAuthOption(
                leadingText: AppStrings.passengerDontHaveAnAccount,
                actionText: AppStrings.passengerSignUp,
                onActionPressed: toggleView,
              ),
            ],
          ),
        );
      },
    );
  }
}
