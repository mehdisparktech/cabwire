import 'package:cabwire/presentation/driver/auth/ui/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_email_verify_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/domain/driver/auth/models/driver_registration.dart';
import 'package:cabwire/domain/driver/auth/usecases/register_usecase.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_confirm_information_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_license_information.dart';
import 'package:cabwire/presentation/driver/auth/ui/driver_vehicles_information_screen.dart';

/// Presenter for the sign-up process
///
/// Manages the state for the entire registration flow
class DriverSignUpPresenter extends BasePresenter<DriverSignUpUiState> {
  // Form keys for each screen
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> confirmInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> licenseInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> vehicleInfoFormKey = GlobalKey<FormState>();

  // Sign up screen controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Email verification controllers
  final List<TextEditingController> verificationCodeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> verificationCodeFocusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  // Confirm information screen controllers
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  String? profileImagePath;

  // License information screen controllers
  final TextEditingController driverLicenseNumberController =
      TextEditingController();
  final TextEditingController licenseExpiryDateController =
      TextEditingController();
  final TextEditingController driverLicenseImageController =
      TextEditingController();
  String? licenseImagePath;

  // Vehicle information screen controllers
  final TextEditingController vehiclesMakeController = TextEditingController();
  final TextEditingController vehiclesModelController = TextEditingController();
  final TextEditingController vehiclesYearController = TextEditingController();
  final TextEditingController vehiclesRegistrationNumberController =
      TextEditingController();
  final TextEditingController vehiclesInsuranceNumberController =
      TextEditingController();
  final TextEditingController vehicleCategoryController =
      TextEditingController();
  final TextEditingController vehiclesPictureController =
      TextEditingController();
  String? vehicleImagePath;

  // Registration state
  final Obs<DriverSignUpUiState> uiState = Obs(DriverSignUpUiState.empty());
  DriverSignUpUiState get currentUiState => uiState.value;

  // Use case for registration
  final RegisterUseCase _registerUseCase;

  // Reset password controllers
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetConfirmPasswordController =
      TextEditingController();
  bool resetObscurePassword = true;
  bool resetObscureConfirmPassword = true;
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

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

  // Email verification handlers
  void onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      verificationCodeFocusNodes[index + 1].requestFocus();
    }
  }

  void resendVerificationCode() {
    // Implementation for resending verification code
    // This could call an API or other service
    addUserMessage('Verification code resent');
  }

  String getMaskedEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return email;
    return email.replaceRange(3, email.indexOf('@'), '...');
  }

  void verifyEmailCode(BuildContext context, bool isSignUp) {
    // Get the combined code from all controllers
    String code =
        verificationCodeControllers.map((controller) => controller.text).join();

    // Validate the code
    if (code.length == 6) {
      // Here we would normally verify the code with an API
      // For now, we just move to the next screen based on isSignUp flag

      if (isSignUp) {
        // Clear previous screens to avoid key conflicts
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) =>
                    const ConfirmInformationScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        // Clear previous screens to avoid key conflicts
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) =>
                    const ResetPasswordScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
          (route) => false, // Remove all previous routes
        );
      }
    } else {
      addUserMessage('Please enter a valid 6-digit code');
    }
  }

  // Handle sign-up button press
  Future<void> onSignUp(BuildContext context) async {
    if (signUpFormKey.currentState?.validate() ?? false) {
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

      // Pre-fill name from the previous step for confirm info screen
      phoneNumberController.text = nameController.text.trim();

      // Navigate to email verification screen first
      if (context.mounted) {
        NavigationUtility.slideRight(
          context,
          const DriverEmailVerificationScreen(isSignUp: true),
        );
      }
    }
  }

  // Upload profile picture
  void uploadProfilePicture() {
    // This would be implemented with image picker
    // For now, we'll just set a dummy path
    profileImagePath = 'dummy_profile_path';
  }

  // Select date of birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ), // Default to 18 years ago
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirthController.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // Show gender selection bottom sheet
  void showGenderSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['Male', 'Female', 'Other']
                    .map(
                      (gender) => ListTile(
                        title: Text(gender),
                        onTap: () {
                          genderController.text = gender;
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList(),
          ),
    );
  }

  // Confirm personal information and navigate to license screen
  void confirmPersonalInformation(BuildContext context) {
    if (confirmInfoFormKey.currentState?.validate() ?? false) {
      // Update registration data
      updatePersonalInfo(
        phone: phoneNumberController.text.trim(),
        gender: genderController.text.trim(),
        dateOfBirth: dateOfBirthController.text.trim(),
        profileImage: profileImagePath,
      );

      // Navigate to next screen
      NavigationUtility.slideRight(
        context,
        const DriverLicenseInformationScreen(),
      );
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

  // Select license expiry date
  Future<void> selectLicenseExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 365),
      ), // Default to 1 year from now
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 10),
      ), // Allow up to 10 years
    );

    if (picked != null) {
      licenseExpiryDateController.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // Select license image
  void selectLicenseImage() {
    // This would be implemented with image picker
    // For now, we'll just set a dummy path
    licenseImagePath = 'dummy_license_path';
    driverLicenseImageController.text = 'License image selected';
  }

  // Confirm license information and navigate to vehicle screen
  void confirmLicenseInformation(BuildContext context) {
    if (licenseInfoFormKey.currentState?.validate() ?? false) {
      // Update license information
      updateLicenseInfo(
        licenseNumber: driverLicenseNumberController.text.trim(),
        licenseExpiryDate: licenseExpiryDateController.text.trim(),
        licenseImage: licenseImagePath,
      );

      // Navigate to next screen
      NavigationUtility.slideRight(context, const VehiclesInformationScreen());
    }
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

  // Select vehicle image
  void selectVehicleImage() {
    // This would be implemented with image picker
    // For now, we'll just set a dummy path
    vehicleImagePath = 'dummy_vehicle_path';
    vehiclesPictureController.text = 'Vehicle image selected';
  }

  // Show vehicle category selection bottom sheet
  void showVehicleCategorySelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children:
                [
                      'Sedan',
                      'SUV',
                      'Hatchback',
                      'Convertible',
                      'Van',
                      'Truck',
                      'Motorcycle',
                      'Other',
                    ]
                    .map(
                      (category) => ListTile(
                        title: Text(category),
                        onTap: () {
                          vehicleCategoryController.text = category;
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList(),
          ),
    );
  }

  // Confirm vehicle information and complete registration
  void confirmVehicleInformation(BuildContext context) {
    if (vehicleInfoFormKey.currentState?.validate() ?? false) {
      // Update vehicle information
      updateVehicleInfo(
        vehicleMake: vehiclesMakeController.text.trim(),
        vehicleModel: vehiclesModelController.text.trim(),
        vehicleYear: vehiclesYearController.text.trim(),
        vehicleRegistrationNumber:
            vehiclesRegistrationNumberController.text.trim(),
        vehicleInsuranceNumber: vehiclesInsuranceNumberController.text.trim(),
        vehicleCategory: vehicleCategoryController.text.trim(),
        vehicleImage: vehicleImagePath,
      );

      // Complete registration process
      completeRegistration(context);
    }
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
            // Go back to login screen with clear navigation stack
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) => const AuthNavigator(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              (route) => false, // Remove all previous routes
            );
          }
        },
      );
    });
  }

  // Toggle reset password visibility
  void toggleResetPasswordVisibility() {
    resetObscurePassword = !resetObscurePassword;
    uiState.value = currentUiState.copyWith(); // Trigger UI update
  }

  // Toggle reset confirm password visibility
  void toggleResetConfirmPasswordVisibility() {
    resetObscureConfirmPassword = !resetObscureConfirmPassword;
    uiState.value = currentUiState.copyWith(); // Trigger UI update
  }

  // Reset password
  void resetPassword(BuildContext context) {
    if (resetPasswordFormKey.currentState?.validate() ?? false) {
      // Here we would typically call an API to reset the password
      // Use pushAndRemoveUntil to clear the navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation1, animation2) => const AuthNavigator(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
        (route) => false, // Remove all previous routes
      );
    }
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
    // Sign up controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    // Email verification controllers
    for (var controller in verificationCodeControllers) {
      controller.dispose();
    }
    for (var focusNode in verificationCodeFocusNodes) {
      focusNode.dispose();
    }

    // Confirm info controllers
    phoneNumberController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();

    // License info controllers
    driverLicenseNumberController.dispose();
    licenseExpiryDateController.dispose();
    driverLicenseImageController.dispose();

    // Vehicle info controllers
    vehiclesMakeController.dispose();
    vehiclesModelController.dispose();
    vehiclesYearController.dispose();
    vehiclesRegistrationNumberController.dispose();
    vehiclesInsuranceNumberController.dispose();
    vehicleCategoryController.dispose();
    vehiclesPictureController.dispose();

    // Reset password controllers
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();

    super.dispose();
  }
}

// Needed for the import
class DriverLoginScreen {
  final VoidCallback toggleView;
  const DriverLoginScreen({required this.toggleView});
}
