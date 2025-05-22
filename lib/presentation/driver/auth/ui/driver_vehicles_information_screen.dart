// ignore_for_file: unused_import

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_login_screen.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';

/// Screen for vehicle information
///
/// Fourth and final step in the registration flow
class VehiclesInformationScreen extends StatefulWidget {
  const VehiclesInformationScreen({super.key});

  @override
  State<VehiclesInformationScreen> createState() =>
      _VehiclesInformationScreenState();
}

class _VehiclesInformationScreenState extends State<VehiclesInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehiclesMakeController = TextEditingController();
  final TextEditingController _vehiclesModelController =
      TextEditingController();
  final TextEditingController _vehiclesYearController = TextEditingController();
  final TextEditingController _vehiclesRegistrationNumberController =
      TextEditingController();
  final TextEditingController _vehiclesInsuranceNumberController =
      TextEditingController();
  final TextEditingController _vehicleCategoryController =
      TextEditingController();
  final TextEditingController _vehiclesPictureController =
      TextEditingController();
  String? _vehicleImagePath;

  // Get presenter from service locator
  late final DriverSignUpPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = locate<DriverSignUpPresenter>();
  }

  @override
  void dispose() {
    _vehiclesMakeController.dispose();
    _vehiclesModelController.dispose();
    _vehiclesYearController.dispose();
    _vehiclesRegistrationNumberController.dispose();
    _vehiclesInsuranceNumberController.dispose();
    _vehicleCategoryController.dispose();
    _vehiclesPictureController.dispose();
    super.dispose();
  }

  void _confirmInformation() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update vehicle information in presenter
      _presenter.updateVehicleInfo(
        vehicleMake: _vehiclesMakeController.text.trim(),
        vehicleModel: _vehiclesModelController.text.trim(),
        vehicleYear: _vehiclesYearController.text.trim(),
        vehicleRegistrationNumber:
            _vehiclesRegistrationNumberController.text.trim(),
        vehicleInsuranceNumber: _vehiclesInsuranceNumberController.text.trim(),
        vehicleCategory: _vehicleCategoryController.text.trim(),
        vehicleImage: _vehicleImagePath,
      );

      // Complete registration process
      _presenter.completeRegistration(context);
    }
  }

  void _selectVehicleImage() {
    // This would be implemented with image picker
    // For now, we'll just set a dummy path
    setState(() {
      _vehicleImagePath = 'dummy_vehicle_path';
      _vehiclesPictureController.text = 'Vehicle image selected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Vehicles Information",
      subtitle: "Please confirm your vehicles information to continue.",
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: _buildFormFields(),
        actionButton: CustomButton(
          text: "Complete Registration",
          onPressed: _confirmInformation,
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      CustomTextFormField(
        controller: _vehiclesMakeController,
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
        controller: _vehiclesModelController,
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
        controller: _vehiclesYearController,
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
        controller: _vehiclesRegistrationNumberController,
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
        controller: _vehiclesInsuranceNumberController,
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
        controller: _vehiclesPictureController,
        hintText: 'Upload Your Vehicles Picture',
        readOnly: true,
        suffixIcon: const Icon(Icons.add_a_photo_outlined),
        onTap: _selectVehicleImage,
      ),
      gapH20,
      CustomTextFormField(
        controller: _vehicleCategoryController,
        hintText: 'Select Your Vehicle Category',
        suffixIcon: const Icon(Icons.keyboard_arrow_down),
        readOnly: true,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please select a category',
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder:
                (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      [
                            'Sedan',
                            'SUV',
                            'Hatchback',
                            'Convertible',
                            'Van',
                            'Truck',
                            'Motorcycle',
                            'Other',
                          ]
                          .map(
                            (category) => ListTile(
                              title: Text(category),
                              onTap: () {
                                setState(() {
                                  _vehicleCategoryController.text = category;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          )
                          .toList(),
                ),
          );
        },
      ),
    ];
  }
}
