import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/auth/auth_form_container.dart';
import 'package:cabwire/presentation/common/components/auth/auth_screen_wrapper.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/passenger/auth/presenter/passenger_set_location_presenter.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SetLocationScreen extends StatelessWidget {
  const SetLocationScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final PassengerSetLocationPresenter presenter =
        locate<PassengerSetLocationPresenter>();

    return AuthScreenWrapper(
      title: "Set Location",
      subtitle: "Please set your location to continue.",
      textColor: Colors.white,
      child: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;

          if (uiState.userMessage != null && uiState.userMessage!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              presenter.addUserMessage("");
            });
          }
          return AuthFormContainer(
            logoAssetPath: AppAssets.icPassengerLogo,
            logoAssetPath2: AppAssets.icCabwireLogo,
            formKey: presenter.formKey,
            formFields: [
              Container(
                height: 54.px,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.px),
                  border: Border.all(color: AppColor.activeIndicator),
                ),
                child: Center(
                  child: Text(
                    "Current Location",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.activeIndicator,
                    ),
                  ),
                ),
              ),
              gapH16,
              CustomTextFormField(
                controller: presenter.locationController,
                hintText: 'Enter a new address',
                prefixIcon: const Icon(Icons.location_on),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new address';
                  }
                  return null;
                },
              ),
            ],
            actionButton: CustomButton(
              text: "Complete",
              onPressed:
                  () =>
                      presenter.uiState.value.isLoading
                          ? null
                          : presenter.setLocation(email),
              isLoading: uiState.isLoading,
            ),
          );
        },
      ),
    );
  }
}
