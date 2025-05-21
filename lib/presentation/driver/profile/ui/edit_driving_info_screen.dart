import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_text.dart'; // Added
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_presenter.dart';
import 'package:flutter/material.dart';

class EditDrivingInfoScreen extends StatelessWidget {
  final DriverProfilePresenter presenter = locate<DriverProfilePresenter>();

  EditDrivingInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Driving Information', // Changed title
        showBackButton: true,
      ),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;
          if (uiState.userMessage!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              presenter.addUserMessage('');
            });
          }
          return Padding(
            // Added overall padding
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Expanded(
                  // To allow scrolling if content overflows
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(text: 'Driving License Number'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Driving License Number',
                          controller: presenter.drivingLicenseNumberController,
                        ),
                        gapH20,
                        const CommonText(text: 'License Expiry Date'), gapH10,
                        CustomTextFormField(
                          hintText: 'YYYY-MM-DD',
                          controller:
                              presenter
                                  .drivingLicenseExpiryDateController /* onTap: showDatePicker */,
                        ),
                        gapH20,
                        const CommonText(text: 'License Issue Date'), gapH10,
                        CustomTextFormField(
                          hintText: 'YYYY-MM-DD',
                          controller:
                              presenter
                                  .drivingLicenseIssuingDateController /* onTap: showDatePicker */,
                        ),
                        // Add more fields as needed, your original code had duplicates
                        // For example:
                        // gapH20,
                        // CommonText(text: 'Vehicle Registration Number'), gapH10,
                        // CustomTextFormField(hintText: 'Enter Vehicle Reg. No.', controller: presenter.vehicleRegNoController),
                      ],
                    ),
                  ),
                ),
                // Spacer(), // Removed Spacer to use Padding for button
                Padding(
                  // Added padding for the button
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CustomButton(
                    text: 'Save Information',
                    onPressed: presenter.saveDrivingInfo,
                    radius: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
