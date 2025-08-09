// ignore_for_file: unused_import

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_login_screen.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../common/components/auth/custom_text_form_field.dart';
import '../../../../common/components/auth/custom_button.dart';
import '../../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../../common/components/auth/auth_form_container.dart';
import '../../../../common/components/auth/auth_validators.dart';

/// Screen for vehicle information
///
/// Fourth and final step in the registration flow
class VehiclesInformationScreen extends StatelessWidget {
  const VehiclesInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final presenter = locate<DriverSignUpPresenter>();

    return AuthScreenWrapper(
      title: AppStrings.driverVehiclesInformation,
      subtitle: AppStrings.driverPleaseConfirmVehiclesInformation,
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.vehicleInfoFormKey,
        formFields: _buildFormFields(context, presenter),
        actionButton: CustomButton(
          text: AppStrings.driverCompleteRegistration,
          onPressed: () => presenter.confirmVehicleInformation(context),
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
      CustomTextFormField(
        controller: presenter.vehiclesMakeController,
        hintText: AppStrings.driverVehiclesMakeEnter,
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter vehicle make',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehiclesModelController,
        hintText: AppStrings.driverVehiclesModelEnter,
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter vehicle model',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehiclesYearController,
        hintText: AppStrings.driverVehiclesYearEnter,
        keyboardType: TextInputType.number,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter vehicle year',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehiclesRegistrationNumberController,
        hintText: AppStrings.driverVehiclesRegistrationNumberEnter,
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter registration number',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehiclesInsuranceNumberController,
        hintText: AppStrings.driverVehiclesInsuranceNumberEnter,
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter Insurance Policy Number',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehiclesFrontPictureController,
        hintText: 'Upload Vehicle Front Photo (plate visible)',
        readOnly: true,
        suffixIcon: const Icon(Icons.add_a_photo_outlined),
        onTap: () => presenter.selectVehicleFrontImage(context),
      ),
      gapH12,
      CustomTextFormField(
        controller: presenter.vehiclesBackPictureController,
        hintText: 'Upload Vehicle Back Photo (plate visible)',
        readOnly: true,
        suffixIcon: const Icon(Icons.add_a_photo_outlined),
        onTap: () => presenter.selectVehicleBackImage(context),
      ),
      gapH20,
      // Vehicle image previews
      if (presenter.vehicleFrontImagePath != null)
        Container(
          width: double.infinity,
          height: px180,
          margin: EdgeInsets.symmetric(vertical: px10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(px8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(px8),
            child: Image.file(
              File(presenter.vehicleFrontImagePath!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      if (presenter.vehicleBackImagePath != null)
        Container(
          width: double.infinity,
          height: px180,
          margin: EdgeInsets.symmetric(vertical: px10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(px8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(px8),
            child: Image.file(
              File(presenter.vehicleBackImagePath!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehicleCategoryController,
        hintText: 'Select Your Vehicle Category',
        suffixIcon: const Icon(Icons.keyboard_arrow_down),
        readOnly: true,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please select a category',
        onTap: () => presenter.showVehicleCategorySelectionSheet(context),
      ),
    ];
  }
}
