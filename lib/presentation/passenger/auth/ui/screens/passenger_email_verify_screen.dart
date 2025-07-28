import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_email_verify_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final bool isSignUp;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.isSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final PassengerEmailVerifyPresenter presenter =
        locate<PassengerEmailVerifyPresenter>();
    presenter.uiState.value = presenter.uiState.value.copyWith(
      email: email,
      isSignUp: isSignUp,
    );

    return AuthScreenWrapper(
      title: "Verify Email",
      subtitle: "Please enter the code sent to your email",
      textColor: Colors.white,
      child: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;
          if (uiState.userMessage != null) {
            // Show toast or snackbar with the message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              // Clear the message after showing it
              presenter.addUserMessage("");
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppLogoDisplay(
                logoAssetPath: AppAssets.icPassengerLogo,
                logoAssetPath2: AppAssets.icCabwireLogo,
              ),
              const SizedBox(height: 40),
              Text(
                "We've Sent a Code to ${presenter.maskedEmail}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildVerificationCodeFields(context, presenter),
              const SizedBox(height: 20),
              _buildResendCodeRow(context, presenter),
              const SizedBox(height: 30),
              _buildVerifyButton(context, presenter, uiState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerificationCodeFields(
    BuildContext context,
    PassengerEmailVerifyPresenter presenter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (index) => SizedBox(
          width: 40,
          height: 50,
          child: TextField(
            controller: presenter.codeControllers[index],
            focusNode: presenter.codeFocusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
            onChanged: (value) => presenter.onCodeDigitInput(index, value),
          ),
        ),
      ),
    );
  }

  Widget _buildResendCodeRow(
    BuildContext context,
    PassengerEmailVerifyPresenter presenter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "If you didn't receive a code: ",
          style: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        TextButton(
          onPressed: presenter.resendCode,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Resend",
            style: TextStyle(
              color: context.color.primaryBtn,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(
    BuildContext context,
    PassengerEmailVerifyPresenter presenter,
    dynamic uiState,
  ) {
    return CustomButton(
      text: "Verify",
      onPressed: () {
        if (!uiState.isLoading) {
          presenter.verifyCode();
        }
      },
      isLoading: uiState.isLoading,
    );
  }
}
