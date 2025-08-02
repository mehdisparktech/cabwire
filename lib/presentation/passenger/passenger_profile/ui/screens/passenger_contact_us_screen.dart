import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_profile_presenter.dart';
import 'package:flutter/material.dart';

class PassengerContactUsScreen extends StatelessWidget {
  final PassengerProfilePresenter presenter =
      locate<PassengerProfilePresenter>();

  PassengerContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Contact Us', showBackButton: true),
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
          return Column(
            children: [
              Expanded(
                // To allow scrolling for the form
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      gapH20,
                      Container(
                        margin: const EdgeInsets.all(14),
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
                            CommonText(
                              text: 'Get in Touch', // Changed title
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            gapH20,
                            const CommonText(text: 'Name'),
                            gapH10,
                            CustomTextFormField(
                              hintText: 'Enter Your Name',
                              controller: presenter.contactNameController,
                            ),
                            gapH10,
                            const CommonText(text: 'Email'),
                            gapH10,
                            CustomTextFormField(
                              hintText: 'Enter Your Email',
                              controller: presenter.contactEmailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            gapH10,
                            const CommonText(text: 'Phone Number (Optional)'),
                            gapH10,
                            CustomTextFormField(
                              hintText: 'Enter Your Phone Number',
                              controller:
                                  presenter.contactPhoneNumberController,
                              keyboardType: TextInputType.phone,
                            ),
                            gapH10,
                            const CommonText(text: 'Message'),
                            gapH10,
                            CustomTextFormField(
                              hintText: 'Type your message here...',
                              controller: presenter.contactMessageController,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spacer(), // Removed spacer
              Padding(
                // Added padding for the button
                padding: const EdgeInsets.all(14.0),
                child: CustomButton(
                  text: 'Submit Message',
                  onPressed: presenter.submitContactUsForm,
                  radius: 10,
                ),
              ),
              gapH20,
            ],
          );
        },
      ),
    );
  }
}
