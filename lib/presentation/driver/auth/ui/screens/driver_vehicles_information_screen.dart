// ignore_for_file: unused_import

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_login_screen.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
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
      title: "Vehicles Information",
      subtitle: "Please confirm your vehicles information to continue.",
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: presenter.vehicleInfoFormKey,
        formFields: _buildFormFields(context, presenter),
        actionButton: CustomButton(
          text: "Complete Registration",
          onPressed: () => presenter.confirmVehicleInformation(context),
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
        hintText: 'Enter Vehicles Make',
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
        hintText: 'Enter Vehicles Model',
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
        hintText: 'Enter Vehicles Year',
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
        hintText: 'Enter Vehicles Registration Number',
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
        hintText: 'Enter Vehicles Insurance Number',
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please enter insurance number',
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.vehiclesPictureController,
        hintText: 'Upload Your Vehicles Picture',
        readOnly: true,
        suffixIcon: const Icon(Icons.add_a_photo_outlined),
        onTap: () => presenter.selectVehicleImage(),
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
