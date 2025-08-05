import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/static/app_strings.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_validators.dart';
import 'dart:io';

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
      title: AppStrings.driverConfirmInformation,
      subtitle: AppStrings.driverConfirmInformationHint,
      textColor: context.color.blackColor100,
      child: Column(
        children: [
          // Profile Picture Upload
          Center(
            child: GestureDetector(
              onTap: () => presenter.uploadProfilePicture(context),
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
                              child: Image.file(
                                File(presenter.profileImagePath!),
                                width: px120,
                                height: px120,
                                fit: BoxFit.cover,
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
            AppStrings.driverUploadProfilePicture,
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
              text: AppStrings.driverContinue,
              onPressed: () => presenter.confirmPersonalInformation(context),
              isLoading: presenter.uiState.value.isLoading,
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
        hintText: AppStrings.driverName,
        keyboardType: TextInputType.name,
        validator: AuthValidators.validateName,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.phoneNumberController,
        hintText: AppStrings.driverPhoneNumber,
        keyboardType: TextInputType.phone,
        validator: AuthValidators.validatePhoneNumber,
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.genderController,
        hintText: AppStrings.driverGender,
        suffixIcon: const Icon(Icons.keyboard_arrow_down),
        readOnly: true,
        onTap: () => presenter.showGenderSelectionSheet(context),
      ),
      gapH20,
      CustomTextFormField(
        controller: presenter.dateOfBirthController,
        hintText: AppStrings.driverDateOfBirth,
        suffixIcon: Icon(Icons.calendar_today, size: px20),
        readOnly: true,
        onTap: () => presenter.selectDateOfBirth(context),
      ),
    ];
  }
}
