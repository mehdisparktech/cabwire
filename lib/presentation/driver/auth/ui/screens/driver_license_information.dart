import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import '../../../../common/components/auth/custom_text_form_field.dart';
import '../../../../common/components/auth/custom_button.dart';
import '../../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../../common/components/auth/auth_form_container.dart';

/// Screen for driver license information
///
/// Third step in the registration flow
class DriverLicenseInformationScreen extends StatelessWidget {
  const DriverLicenseInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final presenter = locate<DriverSignUpPresenter>();

    return AuthScreenWrapper(
      title: "Driver License Information",
      subtitle: "Please confirm your driver license information to continue.",
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.licenseInfoFormKey,
        formFields: _buildFormFields(context, presenter),
        actionButton: CustomButton(
          text: "Continue",
          onPressed: () => presenter.confirmLicenseInformation(context),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(
    BuildContext context,
    DriverSignUpPresenter presenter,
  ) {
    return [
      AppLogoDisplay(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.driverLicenseNumberController,
        hintText: 'Driver License Number',
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter license number',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.licenseExpiryDateController,
        hintText: 'License Expiry Date',
        suffixIcon: Icon(Icons.calendar_today, size: px20),
        readOnly: true,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please select expiry date',
        onTap: () => presenter.selectLicenseExpiryDate(context),
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.driverLicenseImageController,
        hintText: 'Upload Your Driver License',
        readOnly: true,
        suffixIcon: Icon(Icons.add_a_photo_outlined, size: px20),
        onTap: () => presenter.selectLicenseImage(),
      ),
      gapH20,
    ];
  }
}
