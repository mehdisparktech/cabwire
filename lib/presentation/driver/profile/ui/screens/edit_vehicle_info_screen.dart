import 'dart:io';

import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_text.dart'; // Added
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_presenter.dart';
import 'package:flutter/material.dart';

class EditVehicleInfoScreen extends StatelessWidget {
  final DriverProfilePresenter presenter = locate<DriverProfilePresenter>();

  EditVehicleInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Vehicle Information', // Changed title
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
                        CommonText(text: 'Vehicle Registration Number'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Vehicle Reg. No.',
                          controller:
                              presenter.vehiclesRegistrationNumberController,
                        ),
                        gapH20,
                        CommonText(text: 'Vehicle Insurance Number'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Vehicle Insurance No.',
                          controller:
                              presenter.vehiclesInsuranceNumberController,
                        ),
                        gapH20,
                        CommonText(text: 'Vehicle Make'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Vehicle Make',
                          controller: presenter.vehiclesMakeController,
                        ),
                        gapH20,
                        CommonText(text: 'Vehicle Model'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Vehicle Model',
                          controller: presenter.vehiclesModelController,
                        ),
                        gapH20,
                        CommonText(text: 'Vehicle Year'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Vehicle Year',
                          controller: presenter.vehiclesYearController,
                        ),
                        gapH20,
                        CommonText(text: 'Vehicle Category'),
                        gapH10,
                        CustomTextFormField(
                          hintText: 'Enter Vehicle Category',
                          controller: presenter.vehiclesCategoryController,
                        ),
                        gapH20,
                        const CommonText(text: 'Vehicle Image'),
                        gapH10,
                        GestureDetector(
                          onTap: () {
                            presenter.pickVehicleImage();
                          },
                          child:
                              presenter.selectedVehicleImageFile != null
                                  ? Image.file(
                                    File(
                                      presenter.selectedVehicleImageFile!.path,
                                    ),
                                    width: double.infinity,
                                    height: 200.px,
                                    fit: BoxFit.cover,
                                  )
                                  : CommonImage(
                                    imageSrc:
                                        ApiEndPoint.imageUrl +
                                        LocalStorage.vehicleImage,
                                    imageType: ImageType.network,
                                    width: double.infinity,
                                    height: 200.px,
                                  ),
                        ),
                        gapH20,
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
