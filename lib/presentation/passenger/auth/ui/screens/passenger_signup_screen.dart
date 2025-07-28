import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_signup_presenter.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/toggle_auth_option.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';

class PassengerSignUpScreen extends StatelessWidget {
  final VoidCallback toggleView;

  const PassengerSignUpScreen({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final presenter = locate<PassengerSignupPresenter>();

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return AuthScreenWrapper(
          title: "Sign Up",
          subtitle: "Please Register To Login.",
          textColor: Colors.white,
          child: AuthFormContainer(
            logoAssetPath: AppAssets.icPassengerLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.formKey,
            formFields: [
              CustomTextFormField(
                controller: presenter.nameController,
                hintText: 'Enter Full Name Here',
                validator: AuthValidators.validateName,
              ),
              gapH10,
              CustomTextFormField(
                controller: presenter.emailController,
                hintText: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidators.validateEmail,
              ),
              gapH10,
              CustomTextFormField(
                controller: presenter.passwordController,
                hintText: 'Password',
                isPassword: true,
                obscureTextValue: presenter.currentUiState.obscurePassword,
                onVisibilityToggle: presenter.togglePasswordVisibility,
                validator: AuthValidators.validatePassword,
              ),
              gapH10,
              CustomTextFormField(
                controller: presenter.confirmPasswordController,
                hintText: 'Confirm Password',
                isPassword: true,
                obscureTextValue:
                    presenter.currentUiState.obscureConfirmPassword,
                onVisibilityToggle: presenter.toggleConfirmPasswordVisibility,
                validator:
                    (value) => AuthValidators.validateConfirmPassword(
                      value,
                      presenter.passwordController.text,
                    ),
              ),
            ],
            actionButton: CustomButton(
              text: "Sign Up",
              onPressed:
                  () =>
                      presenter.uiState.value.isLoading
                          ? null
                          : presenter.signupPassenger(context),
              isLoading: presenter.uiState.value.isLoading,
            ),
            bottomWidgets: [
              ToggleAuthOption(
                leadingText: "All Ready Sign Up?",
                actionText: "Sign In",
                onActionPressed: toggleView,
              ),
            ],
          ),
        );
      },
    );
  }
}
