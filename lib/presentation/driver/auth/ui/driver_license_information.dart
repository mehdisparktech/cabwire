import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_vehicles_information_screen.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';

class DriverLicenseInformationScreen extends StatefulWidget {
  const DriverLicenseInformationScreen({super.key});

  @override
  State<DriverLicenseInformationScreen> createState() =>
      _DriverLicenseInformationScreenState();
}

class _DriverLicenseInformationScreenState
    extends State<DriverLicenseInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _driverLicenseNumberController =
      TextEditingController();
  final TextEditingController _licenseExpiryDateController =
      TextEditingController();
  final TextEditingController _driverLicenseImageController =
      TextEditingController();

  @override
  void dispose() {
    _driverLicenseNumberController.dispose();
    _licenseExpiryDateController.dispose();
    _driverLicenseImageController.dispose();
    super.dispose();
  }

  void _confirmInformation() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(() => VehiclesInformationScreen());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _licenseExpiryDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Driver License Information",
      subtitle: "Please confirm your driver license information to continue.",
      textColor: Colors.black,
      child:
      // Form fields in AuthFormContainer
      AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: [
          AppLogoDisplay(
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
          ),
          gapH20,
          CustomTextFormField(
            controller: _driverLicenseNumberController,
            hintText: 'Driver License Number',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _licenseExpiryDateController,
            hintText: 'License Expiry Date',
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          gapH20,
          CustomTextFormField(
            controller: _driverLicenseImageController,
            hintText: 'Upload Your Driver License',
            readOnly: true,
            suffixIcon: const Icon(Icons.add_a_photo_outlined),
          ),
          gapH20,
        ],
        actionButton: CustomButton(
          text: "Continue",
          onPressed: _confirmInformation,
        ),
      ),
    );
  }
}
