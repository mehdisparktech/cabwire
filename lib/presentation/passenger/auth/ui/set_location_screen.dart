import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/auth/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_header.dart';
import '../widgets/app_logo_display.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _setLocation() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(() => LoginScreen(toggleView: () {}));
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
                title: "Set Location",
                subtitle: "Please set your location to continue.",
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

                          gapH20,
                          CustomTextFormField(
                            controller: _locationController,
                            hintText: 'Enter a new address',
                            prefixIcon: Icon(Icons.location_on),
                            isPassword: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new address';
                              }
                              return null;
                            },
                          ),

                          gapH20,
                          CustomButton(
                            text: "Complete",
                            onPressed: _setLocation,
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
