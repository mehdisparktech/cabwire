import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/auth/ui/set_location_screen.dart';
import 'package:cabwire/presentation/passenger/auth/widgets/app_logo_display.dart';
import 'package:cabwire/presentation/passenger/auth/widgets/auth_header.dart';
import 'package:cabwire/presentation/passenger/auth/widgets/custom_button.dart';
import 'package:cabwire/presentation/passenger/auth/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _confirmInformation() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(() => SetLocationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [
                AppColor.passengerPrimaryGradient,
                AppColor.passengerSecondaryGradient,
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gapH30,
              AuthHeader(
                title: "Confirm Information",
                subtitle: "Please confirm your information to continue.",
                color: context.color.whiteColor,
              ),
              gapH30,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.color.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLogoDisplay(
                            logoAssetPath: AppAssets.icPassengerLogo,
                            logoAssetPath2: AppAssets.icCabwireLogo,
                            appName: 'cabwire',
                            color: context.color.primaryBtn,
                          ),
                          gapH30,
                          CustomTextFormField(
                            controller: _nameController,
                            hintText: 'Enter Your Name',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          gapH20,
                          CustomTextFormField(
                            controller: _phoneNumberController,
                            hintText: 'Enter Your Phone Number',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),

                          gapH20,
                          CustomButton(
                            text: "Continue",
                            onPressed: _confirmInformation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
