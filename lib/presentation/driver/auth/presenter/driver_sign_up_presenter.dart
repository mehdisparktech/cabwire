import 'package:cabwire/presentation/driver/auth/ui/driver_auth_navigator_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/domain/driver/auth/models/driver_registration.dart';
import 'package:cabwire/domain/driver/auth/usecases/register_usecase.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_confirm_information_screen.dart';

/// Presenter for the sign-up process
///
/// Manages the state for the entire registration flow
class DriverSignUpPresenter extends BasePresenter<DriverSignUpUiState> {
  // Form key and controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Registration state
  final Obs<DriverSignUpUiState> uiState = Obs(DriverSignUpUiState.empty());
  DriverSignUpUiState get currentUiState => uiState.value;

  // Use case for registration
  final RegisterUseCase _registerUseCase;

  DriverSignUpPresenter(this._registerUseCase);

  // Toggle password visibility
  void togglePasswordVisibility() {
    uiState.value = currentUiState.copyWith(
      obscurePassword: !currentUiState.obscurePassword,
    );
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    uiState.value = currentUiState.copyWith(
      obscureConfirmPassword: !currentUiState.obscureConfirmPassword,
    );
  }

  // Validate password and confirm password
  bool validatePasswords() {
    return passwordController.text == confirmPasswordController.text;
  }

  // Handle sign-up button press
  Future<void> onSignUp(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      if (!validatePasswords()) {
        await addUserMessage('Passwords do not match');
        return;
      }

      // Create registration object with basic info
      final updatedRegistration = DriverRegistration(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Update state with new registration info
      uiState.value = currentUiState.copyWith(
        registration: updatedRegistration,
        currentStep: 1,
      );

      // Navigate to next screen in registration flow
      if (context.mounted) {
        Get.to(() => const ConfirmInformationScreen());
      }
    }
  }

  // Update registration with personal info
  void updatePersonalInfo({
    required String phone,
    required String gender,
    required String dateOfBirth,
    String? profileImage,
  }) {
    final updatedRegistration = currentUiState.registration.copyWith(
      phone: phone,
      gender: gender,
      dateOfBirth: dateOfBirth,
      profileImage: profileImage,
    );

    uiState.value = currentUiState.copyWith(
      registration: updatedRegistration,
      currentStep: 2,
    );
  }

  // Update registration with license info
  void updateLicenseInfo({
    required String licenseNumber,
    required String licenseExpiryDate,
    String? licenseImage,
  }) {
    final updatedRegistration = currentUiState.registration.copyWith(
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
      licenseImage: licenseImage,
    );

    uiState.value = currentUiState.copyWith(
      registration: updatedRegistration,
      currentStep: 3,
    );
  }

  // Update registration with vehicle info
  void updateVehicleInfo({
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleYear,
    required String vehicleRegistrationNumber,
    required String vehicleInsuranceNumber,
    required String vehicleCategory,
    String? vehicleImage,
  }) {
    final updatedRegistration = currentUiState.registration.copyWith(
      vehicleMake: vehicleMake,
      vehicleModel: vehicleModel,
      vehicleYear: vehicleYear,
      vehicleRegistrationNumber: vehicleRegistrationNumber,
      vehicleInsuranceNumber: vehicleInsuranceNumber,
      vehicleCategory: vehicleCategory,
      vehicleImage: vehicleImage,
    );

    uiState.value = currentUiState.copyWith(
      registration: updatedRegistration,
      currentStep: 4,
    );
  }

  // Complete registration process
  Future<void> completeRegistration(BuildContext context) async {
    await executeTaskWithLoading(() async {
      final result = await _registerUseCase.execute(
        registration: currentUiState.registration,
      );

      await result.fold(
        // On error
        (errorMessage) async {
          await addUserMessage(errorMessage);
        },
        // On success
        (user) async {
          uiState.value = currentUiState.copyWith(isRegistered: true);

          // Navigate to login or home screen
          if (context.mounted) {
            // Go back to login screen
            NavigationUtility.fadeReplacement(context, const AuthNavigator());
          }
        },
      );
    });
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

// Needed for the import
class DriverLoginScreen {
  final VoidCallback toggleView;
  const DriverLoginScreen({required this.toggleView});
}
