import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_license_information.dart';
import 'package:flutter/material.dart';
import '../../../common/components/auth/custom_text_form_field.dart';
import '../../../common/components/auth/custom_button.dart';
import '../../../common/components/auth/auth_screen_wrapper.dart';
import '../../../common/components/auth/auth_form_container.dart';
import '../../../common/components/auth/auth_validators.dart';

class ConfirmInformationScreen extends StatefulWidget {
  const ConfirmInformationScreen({super.key});

  @override
  State<ConfirmInformationScreen> createState() =>
      _ConfirmInformationScreenState();
}

class _ConfirmInformationScreenState extends State<ConfirmInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _confirmInformation() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    NavigationUtility.slideRight(context, DriverLicenseInformationScreen());
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
        _dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Confirm Information",
      subtitle: "Please confirm your information to continue.",
      textColor: Colors.black,
      child: Column(
        children: [
          // Profile Picture Upload
          Center(
            child: Stack(
              children: [
                Container(
                  width: px120,
                  height: px120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: px60, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(px8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: px20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          gapH16,
          Text(
            "Upload Your Profile Picture",
            style: TextStyle(fontSize: px16, fontWeight: FontWeight.w500),
          ),

          gapH24,

          // Form fields in AuthFormContainer
          AuthFormContainer(
            showLogo: false,
            logoAssetPath: AppAssets.icDriverLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: _formKey,
            formFields: [
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Enter Your Name',
                keyboardType: TextInputType.name,
                validator: AuthValidators.validateName,
              ),
              gapH20,
              CustomTextFormField(
                controller: _phoneNumberController,
                hintText: 'Enter Your Phone Number',
                keyboardType: TextInputType.phone,
                validator: AuthValidators.validatePhoneNumber,
              ),
              gapH20,
              CustomTextFormField(
                controller: _genderController,
                hintText: 'Select Your Gender',
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
                readOnly: true,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              ['Male', 'Female', 'Other']
                                  .map(
                                    (gender) => ListTile(
                                      title: Text(gender),
                                      onTap: () {
                                        setState(() {
                                          _genderController.text = gender;
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
              gapH20,
              CustomTextFormField(
                controller: _dateOfBirthController,
                hintText: 'Date Of Birth',
                suffixIcon: Icon(Icons.calendar_today, size: px20),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ],
            actionButton: CustomButton(
              text: "Continue",
              onPressed: _confirmInformation,
            ),
          ),
        ],
      ),
    );
  }
}
