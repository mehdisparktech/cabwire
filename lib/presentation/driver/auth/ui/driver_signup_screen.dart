import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/toggle_auth_option.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';

/// Screen for driver registration
///
/// First step in the registration flow, collects basic user information
class DriverSignUpScreen extends StatelessWidget {
  final VoidCallback toggleView;

  const DriverSignUpScreen({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final presenter = locate<DriverSignUpPresenter>();

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final currentUiState = presenter.uiState.value;

        return AuthScreenWrapper(
          title: "Sign Up",
          subtitle: "Please Register To Login.",
          textColor: context.color.blackColor100,
          child: AuthFormContainer(
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.signUpFormKey,
            formFields: _buildFormFields(context, presenter, currentUiState),
            actionButton: _buildSignUpButton(context, presenter),
            bottomWidgets: _buildAlreadyHaveAccountOption(),
          ),
        );
      },
    );
  }

  /// Builds the form fields for the signup screen
  List<Widget> _buildFormFields(
    BuildContext context,
    DriverSignUpPresenter presenter,
    dynamic currentUiState,
  ) {
    return [
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
        obscureTextValue: currentUiState.obscurePassword,
        onVisibilityToggle: presenter.togglePasswordVisibility,
        validator: AuthValidators.validatePassword,
      ),
      gapH10,
      CustomTextFormField(
        controller: presenter.confirmPasswordController,
        hintText: 'Confirm Password',
        isPassword: true,
        obscureTextValue: currentUiState.obscureConfirmPassword,
        onVisibilityToggle: presenter.toggleConfirmPasswordVisibility,
        validator:
            (value) => AuthValidators.validateConfirmPassword(
              value,
              presenter.passwordController.text,
            ),
      ),
    ];
  }

  /// Builds the sign up button
  Widget _buildSignUpButton(
    BuildContext context,
    DriverSignUpPresenter presenter,
  ) {
    return CustomButton(
      text: "Sign Up",
      onPressed: () => presenter.onSignUp(context),
    );
  }

  /// Builds the already have account option at the bottom
  List<Widget> _buildAlreadyHaveAccountOption() {
    return [
      ToggleAuthOption(
        leadingText: "Already Signed Up?",
        actionText: "Sign In",
        onActionPressed: toggleView,
      ),
    ];
  }
}
