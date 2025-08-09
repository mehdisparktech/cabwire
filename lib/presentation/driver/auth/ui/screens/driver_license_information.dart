import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import 'dart:io';
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
      title: AppStrings.driverLicenseInformation,
      subtitle: AppStrings.driverLicenseInformationHint,
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.licenseInfoFormKey,
        formFields: _buildFormFields(context, presenter),
        actionButton: CustomButton(
          text: AppStrings.driverContinue,
          onPressed: () => presenter.confirmLicenseInformation(context),
          isLoading: presenter.uiState.value.isLoading,
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
        hintText: AppStrings.driverLicenseNumber,
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : AppStrings.driverLicenseNumberError,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.licenseExpiryDateController,
        hintText: AppStrings.driverLicenseExpiry,
        suffixIcon: Icon(Icons.calendar_today, size: px20),
        readOnly: true,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : AppStrings.driverLicenseExpiryError,
        onTap: () => presenter.selectLicenseExpiryDate(context),
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.driverLicenseImageController,
        hintText: AppStrings.driverLicenseFront,
        readOnly: true,
        suffixIcon: Icon(Icons.add_a_photo_outlined, size: px20),
        onTap: () => presenter.selectLicenseImage(context),
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.driverLicenseBackImageController,
        hintText: AppStrings.driverLicenseBack,
        readOnly: true,
        suffixIcon: Icon(Icons.add_a_photo_outlined, size: px20),
        onTap: () => presenter.selectLicenseBackImage(context),
      ),
      gapH20,
      // License image preview
      if (presenter.licenseImagePath != null)
        Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(presenter.licenseImagePath!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      if (presenter.licenseBackImagePath != null)
        Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(presenter.licenseBackImagePath!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      gapH20,
    ];
  }
}
