import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_profile_presenter.dart';
import 'package:flutter/material.dart';
// For File type

class PassengerEditProfileInfoScreen extends StatelessWidget {
  final PassengerProfilePresenter presenter =
      locate<PassengerProfilePresenter>();

  PassengerEditProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Change Profile Information',
        showBackButton: true,
      ),
      body: PresentableWidgetBuilder(
        // Wrap with builder if any part of UI needs to react to state changes
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;
          // For displaying user messages (e.g., validation errors)
          if (uiState.userMessage!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              presenter.addUserMessage(''); // Clear message after showing
            });
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        gapH20,
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                // To allow image picking
                                onTap: presenter.pickProfileImage,
                                child: CircleAvatar(
                                  // Use CircleAvatar for cleaner circular image
                                  radius: 80,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                      presenter.selectedProfileImageFile != null
                                          ? FileImage(
                                            presenter.selectedProfileImageFile!,
                                          )
                                          : NetworkImage(
                                            ApiEndPoint.imageUrl +
                                                LocalStorage.myImage,
                                          ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  // Make camera icon tappable too
                                  onTap: presenter.pickProfileImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        gapH20,
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacityInt(0.2),
                            ), // Corrected
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacityInt(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ), // Corrected
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CommonText(text: 'Name'),
                              gapH10,
                              CustomTextFormField(
                                hintText: 'Enter Name',
                                controller: presenter.editNameController,
                              ),
                              gapH10,
                              const CommonText(text: 'Email'),
                              gapH10,
                              CustomTextFormField(
                                readOnly: true,
                                hintText: 'Enter Email',
                                controller: presenter.editEmailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              gapH10,
                              const CommonText(text: 'Phone Number'),
                              gapH10,
                              CustomTextFormField(
                                hintText: 'Enter Phone Number',
                                controller: presenter.editPhoneNumberController,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                        gapH20,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CustomButton(
                    text: 'Save Changes',
                    onPressed: presenter.saveProfileInfo,
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
