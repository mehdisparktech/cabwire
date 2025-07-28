import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
// import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_edit_password_presenter.dart';
import 'package:flutter/material.dart';

class EditPasswordScreen extends StatelessWidget {
  final DriverEditPasswordPresenter presenter =
      locate<DriverEditPasswordPresenter>();

  EditPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Password', showBackButton: true),
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
              gapH20,
              Container(
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ), // Corrected
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ), // Corrected
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CommonText(
                      text: 'Change Password',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    gapH20,
                    const CommonText(text: 'Old Password'), gapH10,
                    CustomTextFormField(
                      hintText: 'Enter Old Password',
                      controller: presenter.currentPasswordController,
                      obscureTextValue: true,
                    ),
                    gapH10,
                    const CommonText(text: 'New Password'), gapH10,
                    CustomTextFormField(
                      hintText: 'Enter New Password',
                      controller: presenter.newPasswordController,
                      obscureTextValue: true,
                    ),
                    gapH10,
                    const CommonText(text: 'Confirm New Password'), gapH10,
                    CustomTextFormField(
                      hintText: 'Confirm New Password',
                      controller: presenter.confirmNewPasswordController,
                      obscureTextValue: true,
                    ),
                    // gapH10, // Removed extra gap
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                // Added padding for the button
                padding: const EdgeInsets.all(14.0),
                child: CustomButton(
                  text: 'Save Password',
                  onPressed: presenter.savePassword,
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
