import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/toggle_auth_option.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_presenter.dart';
import 'package:flutter/material.dart';
import 'driver_forgot_password_screen.dart';

/// Screen that handles driver login
///
/// Presents login form with email and password inputs
/// Redirects to home page on successful login
class DriverLoginScreen extends StatelessWidget {
  final VoidCallback toggleView;

  const DriverLoginScreen({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    // Locate the presenter using the service locator
    final presenter = locate<DriverLoginPresenter>();

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final ui = presenter.uiState.value;

        return AuthScreenWrapper(
          title: AppStrings.driverSignIn,
          subtitle: AppStrings.driverWelcomeBackToCabwire,
          textColor: context.color.blackColor100,
          child: AuthFormContainer(
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.formKey,
            formFields: _buildFormFields(context, presenter, ui),
            actionButton: _buildLoginButton(context, presenter),
            bottomWidgets: _buildSignUpOption(),
          ),
        );
      },
    );
  }

  /// Builds the form fields for email and password
  List<Widget> _buildFormFields(
    BuildContext context,
    DriverLoginPresenter presenter,
    dynamic ui,
  ) {
    return [
      CustomTextFormField(
        controller: presenter.emailController,
        hintText: 'example@email.com',
        keyboardType: TextInputType.emailAddress,
        validator: AuthValidators.validateEmail,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.passwordController,
        hintText: AppStrings.driverPassword,
        isPassword: true,
        obscureTextValue: ui.obscurePassword,
        onVisibilityToggle: presenter.togglePasswordVisibility,
        validator: AuthValidators.validatePassword,
      ),
      gapH10,
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed:
              () => NavigationUtility.slideRight(
                context,
                const ForgotPasswordScreen(),
              ),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AppStrings.driverForgotPassword,
            style: TextStyle(
              color: context.color.blackColor800,
              fontSize: px14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    ];
  }

  /// Builds the login button
  Widget _buildLoginButton(
    BuildContext context,
    DriverLoginPresenter presenter,
  ) {
    return CustomButton(
      text: AppStrings.driverSignIn,
      onPressed: () => presenter.onSignIn(context),
    );
  }

  /// Builds the sign up option at the bottom
  List<Widget> _buildSignUpOption() {
    return [
      ToggleAuthOption(
        leadingText: AppStrings.driverDontHaveAnAccount,
        actionText: AppStrings.driverSignUp,
        onActionPressed: toggleView,
      ),
    ];
  }
}
