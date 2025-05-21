import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/toggle_auth_option.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';

class DriverSignUpScreen extends StatelessWidget {
  final VoidCallback toggleView;

  DriverSignUpScreen({super.key, required this.toggleView});

  final DriverSignUpPresenter presenter = locate<DriverSignUpPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final currentUiState = presenter.uiState.value;
        return AuthScreenWrapper(
          title: "Sign Up",
          subtitle: "Please Register To Login.",
          textColor: Colors.black,
          child: AuthFormContainer(
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.formKey,
            formFields: [
              CustomTextFormField(
                controller: presenter.nameController,
                hintText: 'Enter Full Name Here',
                validator: AuthValidators.validateName,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: presenter.emailController,
                hintText: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidators.validateEmail,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: presenter.passwordController,
                hintText: 'Password',
                isPassword: true,
                obscureTextValue: currentUiState.obscurePassword,
                onVisibilityToggle: presenter.togglePasswordVisibility,
                validator: AuthValidators.validatePassword,
              ),
              const SizedBox(height: 10),
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
            ],
            actionButton: CustomButton(
              text: "Sign Up",
              onPressed: () => presenter.onSignUp(context),
            ),
            bottomWidgets: [
              ToggleAuthOption(
                leadingText: "Already Signed Up?",
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
