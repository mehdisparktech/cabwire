// ignore_for_file: unused_import

import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/driver/auth/ui/login_screen.dart';
import 'package:cabwire/presentation/driver/auth/widgets/app_logo_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_screen_wrapper.dart';
import '../widgets/auth_form_container.dart';
import '../widgets/auth_validators.dart';

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
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(() => LoginScreen(toggleView: () {}));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Vehicles Information",
      subtitle: "Please confirm your vehicles information to continue.",
      child:
      // Form fields in AuthFormContainer
      AuthFormContainer(
        showLogo: false,
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _vehiclesMakeController,
            hintText: 'Enter Vehicles Make',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _vehiclesModelController,
            hintText: 'Enter Vehicles Model',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _vehiclesYearController,
            hintText: 'Enter Vehicles Year',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _vehiclesRegistrationNumberController,
            hintText: 'Enter Vehicles Registration Number',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _vehiclesInsuranceNumberController,
            hintText: 'Enter Vehicles Insurance Number',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _vehiclesPictureController,
            hintText: 'Upload Your Vehicles Picture',
            readOnly: true,
            suffixIcon: const Icon(Icons.add_a_photo_outlined),
          ),
          gapH20,
          CustomTextFormField(
            controller: _vehicleCategoryController,
            hintText: 'Select Your Vehicle Category',
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
            readOnly: true,
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
                                (gender) => ListTile(
                                  title: Text(gender),
                                  onTap: () {
                                    setState(() {
                                      _vehicleCategoryController.text = gender;
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
        ],
        actionButton: CustomButton(
          text: "Continue",
          onPressed: _confirmInformation,
        ),
      ),
    );
  }
}
