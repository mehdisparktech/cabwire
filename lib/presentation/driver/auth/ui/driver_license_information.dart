import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_vehicles_information_screen.dart';
import 'package:cabwire/presentation/common/components/auth/app_logo_display.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';

/// Screen for driver license information
///
/// Third step in the registration flow
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
  String? _licenseImagePath;

  // Get presenter from service locator
  late final DriverSignUpPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = locate<DriverSignUpPresenter>();
  }

  @override
  void dispose() {
    _driverLicenseNumberController.dispose();
    _licenseExpiryDateController.dispose();
    _driverLicenseImageController.dispose();
    super.dispose();
  }

  void _confirmInformation() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update license information in presenter
      _presenter.updateLicenseInfo(
        licenseNumber: _driverLicenseNumberController.text.trim(),
        licenseExpiryDate: _licenseExpiryDateController.text.trim(),
        licenseImage: _licenseImagePath,
      );

      // Navigate to next screen
      NavigationUtility.slideRight(context, const VehiclesInformationScreen());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 365),
      ), // Default to 1 year from now
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 10),
      ), // Allow up to 10 years
    );

    if (picked != null) {
      setState(() {
        _licenseExpiryDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _selectLicenseImage() {
    // This would be implemented with image picker
    // For now, we'll just set a dummy path
    setState(() {
      _licenseImagePath = 'dummy_license_path';
      _driverLicenseImageController.text = 'License image selected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Driver License Information",
      subtitle: "Please confirm your driver license information to continue.",
      textColor: context.color.blackColor100,
      child: AuthFormContainer(
        showLogo: false,
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
        formKey: _formKey,
        formFields: _buildFormFields(),
        actionButton: CustomButton(
          text: "Continue",
          onPressed: _confirmInformation,
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      AppLogoDisplay(
        logoAssetPath: AppAssets.icDriverLogo,
        logoAssetPath2: AppAssets.icCabwireLogo,
      ),
      gapH20,
      CustomTextFormField(
        controller: _driverLicenseNumberController,
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
        controller: _licenseExpiryDateController,
        hintText: 'License Expiry Date',
        suffixIcon: Icon(Icons.calendar_today, size: px20),
        readOnly: true,
        validator:
            (value) =>
                value != null && value.isNotEmpty
                    ? null
                    : 'Please select expiry date',
        onTap: () => _selectDate(context),
      ),
      gapH20,
      CustomTextFormField(
        controller: _driverLicenseImageController,
        hintText: 'Upload Your Driver License',
        readOnly: true,
        suffixIcon: Icon(Icons.add_a_photo_outlined, size: px20),
        onTap: _selectLicenseImage,
      ),
      gapH20,
    ];
  }
}
