import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';

/// Screen for confirming driver's personal information
///
/// Second step in the registration flow
class ConfirmInformationScreen extends StatelessWidget {
  const ConfirmInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get presenter from service locator
    final presenter = locate<DriverSignUpPresenter>();

    return AuthScreenWrapper(
      title: "Confirm Information",
      subtitle: "Please confirm your information to continue.",
      textColor: context.color.blackColor100,
      child: Column(
        children: [
          // Profile Picture Upload
          Center(
            child: GestureDetector(
              onTap: () => presenter.uploadProfilePicture(),
              child: Stack(
                children: [
                  Container(
                    width: px120,
                    height: px120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child:
                        presenter.profileImagePath != null
                            ? ClipOval(
                              child: Icon(
                                Icons.person,
                                size: px60,
                                color: Colors.white,
                              ),
                            )
                            : Icon(
                              Icons.person,
                              size: px60,
                              color: Colors.white,
                            ),
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
            formKey: presenter.confirmInfoFormKey,
            formFields: _buildFormFields(context, presenter),
            actionButton: CustomButton(
              text: "Continue",
              onPressed: () => presenter.confirmPersonalInformation(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields(
    BuildContext context,
    DriverSignUpPresenter presenter,
  ) {
    return [
      CustomTextFormField(
        controller: presenter.nameController,
        hintText: 'Enter Your Name',
        keyboardType: TextInputType.name,
        validator: AuthValidators.validateName,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.phoneNumberController,
        hintText: 'Enter Your Phone Number',
        keyboardType: TextInputType.phone,
        validator: AuthValidators.validatePhoneNumber,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.genderController,
        hintText: 'Select Your Gender',
        suffixIcon: const Icon(Icons.keyboard_arrow_down),
        readOnly: true,
        onTap: () => presenter.showGenderSelectionSheet(context),
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.dateOfBirthController,
        hintText: 'Date Of Birth',
        suffixIcon: Icon(Icons.calendar_today, size: px20),
        readOnly: true,
        onTap: () => presenter.selectDateOfBirth(context),
      ),
    ];
  }
}
