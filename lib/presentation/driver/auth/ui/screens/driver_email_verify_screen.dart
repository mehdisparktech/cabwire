import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_email_verification_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_forgot_password_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../common/components/auth/custom_button.dart';
import '../../../../common/components/auth/auth_screen_wrapper.dart';

/// Email verification screen for driver
///
/// Used for both sign up and forgot password flows
class DriverEmailVerificationScreen extends StatelessWidget {
  final bool isSignUp;

  const DriverEmailVerificationScreen({super.key, required this.isSignUp});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final DriverEmailVerificationPresenter presenter =
        isSignUp
            ? locate<DriverSignUpPresenter>()
            : locate<DriverForgotPasswordPresenter>();

    // Get the email from the presenter
    final email = presenter.emailController.text;

    // Get masked email for display
    final maskedEmail = presenter.getMaskedEmail(email);

    return AuthScreenWrapper(
      title: AppStrings.driverVerifyEmail,
      subtitle: AppStrings.driverEnterCodeEmailError,
      textColor: context.color.blackColor100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppLogoDisplay(
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
          ),
          gapH40,
          Text(
            "${AppStrings.driverWeveSentCode} $maskedEmail",
            style: TextStyle(
              color: context.color.blackColor800,
              fontSize: px16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          gapH30,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => SizedBox(
                width: px40,
                height: px50,
                child: TextField(
                  controller: presenter.verificationCodeControllers[index],
                  focusNode: presenter.verificationCodeFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: px22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(px8),
                      borderSide: BorderSide(
                        color: context.color.blackColor300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(px8),
                      borderSide: BorderSide(
                        color: context.color.blackColor300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(px8),
                      borderSide: BorderSide(
                        color: context.color.primaryBtn,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged:
                      (value) => presenter.onCodeDigitInput(index, value),
                ),
              ),
            ),
          ),
          gapH20,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.driverIfYouDidntReceiveCode,
                style: TextStyle(
                  color: context.color.blackColor800,
                  fontSize: px14,
                ),
              ),
              TextButton(
                onPressed: () => presenter.resendVerificationCode(),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.driverResend,
                  style: TextStyle(
                    color: context.color.primaryBtn,
                    fontSize: px14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          gapH30,
          CustomButton(
            text: AppStrings.driverVerify,
            onPressed: () => presenter.verifyEmailCode(context, isSignUp),
          ),
        ],
      ),
    );
  }
}
