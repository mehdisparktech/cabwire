import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class EditDrivingInfoScreen extends StatelessWidget {
  EditDrivingInfoScreen({super.key});
  final TextEditingController drivingLicenseNumberController =
      TextEditingController();
  final TextEditingController drivingLicenseExpiryDateController =
      TextEditingController();
  final TextEditingController drivingLicenseIssuingDateController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Change Driving Information',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseNumberController,
            ),
            gapH20,
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseExpiryDateController,
            ),
            gapH20,
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseIssuingDateController,
            ),
            gapH20,
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseNumberController,
            ),
            gapH20,
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseExpiryDateController,
            ),
            gapH20,
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseNumberController,
            ),
            gapH20,
            CustomTextFormField(
              hintText: 'Enter Driving License Number',
              controller: drivingLicenseExpiryDateController,
            ),
            Spacer(),
            CustomButton(text: 'Save', onPressed: () {}, radius: 10),
          ],
        ),
      ),
    );
  }
}
