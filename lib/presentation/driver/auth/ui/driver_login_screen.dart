import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/toggle_auth_option.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../driver/auth/ui/driver_forgot_password_screen.dart';
import '../../../../core/static/app_colors.dart';

class DriverLoginScreen extends StatelessWidget {
  final VoidCallback toggleView;

  DriverLoginScreen({super.key, required this.toggleView});

  final DriverLoginPresenter presenter = locate<DriverLoginPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        final ui = presenter.uiState.value;

        return AuthScreenWrapper(
          title: "Sign In",
          subtitle: "Welcome Back To Cabwire.",
          textColor: Colors.black,
          child: AuthFormContainer(
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.formKey,
            formFields: [
              CustomTextFormField(
                controller: presenter.emailController,
                hintText: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidators.validateEmail,
              ),
              gapH20,
              CustomTextFormField(
                controller: presenter.passwordController,
                hintText: 'Password',
                isPassword: true,
                obscureTextValue: ui.obscurePassword,
                onVisibilityToggle: presenter.togglePasswordVisibility,
                validator: AuthValidators.validatePassword,
              ),
              gapH10,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => ForgotPasswordScreen()),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: AppColors.textBlack87,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
            actionButton: CustomButton(
              text: "Sign In",
              onPressed: () => presenter.onSignIn(context),
            ),
            bottomWidgets: [
              ToggleAuthOption(
                leadingText: "Don't Have an Account?",
                actionText: "Sign Up",
                onActionPressed: toggleView,
              ),
            ],
          ),
        );
      },
    );
  }
}
