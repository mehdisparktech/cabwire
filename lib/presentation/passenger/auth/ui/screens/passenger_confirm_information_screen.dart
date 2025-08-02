import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_confirm_information_presenter.dart';
import 'package:flutter/material.dart';

class ConfirmInformationScreen extends StatelessWidget {
  const ConfirmInformationScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final PassengerConfirmInformationPresenter presenter =
        locate<PassengerConfirmInformationPresenter>();

    return AuthScreenWrapper(
      title: "Confirm Information",
      subtitle: "Please confirm your information to continue.",
      textColor: Colors.white,
      child: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;

          if (uiState.userMessage != null && uiState.userMessage!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              presenter.addUserMessage("");
            });
          }

          return AuthFormContainer(
            logoAssetPath: AppAssets.icPassengerLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.formKey,
            formFields: [
              CustomTextFormField(
                controller: presenter.nameController,
                hintText: 'Enter Your Name',
                keyboardType: TextInputType.name,
                validator: AuthValidators.validateName,
              ),
              gapH20,
              CustomTextFormField(
                controller: presenter.phoneNumberController,
                hintText: 'Enter Your Phone Number',
                keyboardType: TextInputType.phone,
                validator: AuthValidators.validatePhoneNumber,
              ),
            ],
            actionButton: CustomButton(
              text: "Continue",
              onPressed: () => presenter.confirmInformation(email),
              isLoading: uiState.isLoading,
            ),
          );
        },
      ),
    );
  }
}
