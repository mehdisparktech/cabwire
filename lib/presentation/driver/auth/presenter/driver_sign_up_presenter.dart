import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_email_verify_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_confirm_information_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_license_information.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_vehicles_information_screen.dart';

// Import the separated files
import 'controllers/driver_sign_up_controllers.dart';
import 'utils/driver_sign_up_constants.dart';
import 'utils/driver_sign_up_navigation.dart';
import 'utils/driver_sign_up_validation.dart';
import 'utils/driver_sign_up_ui_helpers.dart';

class DriverSignUpPresenter extends BasePresenter<DriverSignUpUiState> {
  // Use case dependency
  final DriverAuthRepository _driverAuthRepository;

  // State management
  final Obs<DriverSignUpUiState> uiState = Obs(DriverSignUpUiState.empty());
  DriverSignUpUiState get currentUiState => uiState.value;

  // Controllers - delegated to separate file
  late final DriverSignUpControllers _controllers;

  // Navigation helper
  late final DriverSignUpNavigation _navigation;

  // Validation helper
  late final DriverSignUpValidation _validation;

  // UI helpers
  late final DriverSignUpUIHelpers _uiHelpers;

  DriverSignUpPresenter(this._driverAuthRepository);

  @override
  void onInit() {
    super.onInit();
    _initializeHelpers();
  }

  void _initializeHelpers() {
    _controllers = DriverSignUpControllers();
    _navigation = DriverSignUpNavigation();
    _validation = DriverSignUpValidation();
    _uiHelpers = DriverSignUpUIHelpers();
  }

  // Form keys
  GlobalKey<FormState> get signUpFormKey => _controllers.signUpFormKey;
  GlobalKey<FormState> get confirmInfoFormKey =>
      _controllers.confirmInfoFormKey;
  GlobalKey<FormState> get licenseInfoFormKey =>
      _controllers.licenseInfoFormKey;
  GlobalKey<FormState> get vehicleInfoFormKey =>
      _controllers.vehicleInfoFormKey;
  GlobalKey<FormState> get resetPasswordFormKey =>
      _controllers.resetPasswordFormKey;

  // Controller getters - delegated to controllers class
  TextEditingController get nameController => _controllers.nameController;
  TextEditingController get emailController => _controllers.emailController;
  TextEditingController get passwordController =>
      _controllers.passwordController;
  TextEditingController get confirmPasswordController =>
      _controllers.confirmPasswordController;

  List<TextEditingController> get verificationCodeControllers =>
      _controllers.verificationCodeControllers;
  List<FocusNode> get verificationCodeFocusNodes =>
      _controllers.verificationCodeFocusNodes;

  TextEditingController get phoneNumberController =>
      _controllers.phoneNumberController;
  TextEditingController get genderController => _controllers.genderController;
  TextEditingController get dateOfBirthController =>
      _controllers.dateOfBirthController;
  String? get profileImagePath => _controllers.profileImagePath;

  TextEditingController get driverLicenseNumberController =>
      _controllers.driverLicenseNumberController;
  TextEditingController get licenseExpiryDateController =>
      _controllers.licenseExpiryDateController;
  TextEditingController get driverLicenseImageController =>
      _controllers.driverLicenseImageController;
  String? get licenseImagePath => _controllers.licenseImagePath;

  TextEditingController get vehiclesMakeController =>
      _controllers.vehiclesMakeController;
  TextEditingController get vehiclesModelController =>
      _controllers.vehiclesModelController;
  TextEditingController get vehiclesYearController =>
      _controllers.vehiclesYearController;
  TextEditingController get vehiclesRegistrationNumberController =>
      _controllers.vehiclesRegistrationNumberController;
  TextEditingController get vehiclesInsuranceNumberController =>
      _controllers.vehiclesInsuranceNumberController;
  TextEditingController get vehicleCategoryController =>
      _controllers.vehicleCategoryController;
  TextEditingController get vehiclesPictureController =>
      _controllers.vehiclesPictureController;
  String? get vehicleImagePath => _controllers.vehicleImagePath;

  TextEditingController get resetPasswordController =>
      _controllers.resetPasswordController;
  TextEditingController get resetConfirmPasswordController =>
      _controllers.resetConfirmPasswordController;
  bool get resetObscurePassword => _controllers.resetObscurePassword;
  bool get resetObscureConfirmPassword =>
      _controllers.resetObscureConfirmPassword;

  // Password visibility methods
  void togglePasswordVisibility() =>
      _updateUiState(obscurePassword: !currentUiState.obscurePassword);
  void toggleConfirmPasswordVisibility() => _updateUiState(
    obscureConfirmPassword: !currentUiState.obscureConfirmPassword,
  );
  void toggleResetPasswordVisibility() {
    _controllers.toggleResetPasswordVisibility();
    _updateUiState();
  }

  void toggleResetConfirmPasswordVisibility() {
    _controllers.toggleResetConfirmPasswordVisibility();
    _updateUiState();
  }

  // Validation methods - delegated to validation helper
  bool validatePasswords() => _validation.validatePasswords(
    passwordController.text,
    confirmPasswordController.text,
  );

  // Email verification methods
  void onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty &&
        index < DriverSignUpConstants.verificationCodeLength - 1) {
      verificationCodeFocusNodes[index + 1].requestFocus();
    }
  }

  void resendVerificationCode() {
    addUserMessage('Verification code resent');
  }

  String getMaskedEmail(String email) => _validation.getMaskedEmail(email);

  Future<void> verifyEmailCode(BuildContext context, bool isSignUp) async {
    final code =
        verificationCodeControllers.map((controller) => controller.text).join();

    if (code.length != DriverSignUpConstants.verificationCodeLength) {
      await addUserMessage(
        'Please enter a valid ${DriverSignUpConstants.verificationCodeLength}-digit code',
      );
      return;
    }

    final targetScreen =
        isSignUp
            ? const ConfirmInformationScreen()
            : const ResetPasswordScreen();

    if (context.mounted) {
      _navigation.navigateWithSlideTransition(
        context,
        targetScreen,
        clearStack: true,
      );
    }
  }

  // Sign-up flow methods
  Future<void> onSignUp(BuildContext context) async {
    if (!_validation.validateForm(signUpFormKey)) return;

    if (!validatePasswords()) {
      await addUserMessage('Passwords do not match');
      return;
    }

    await _updateRegistrationStep1();

    if (context.mounted) {
      NavigationUtility.slideRight(
        context,
        const DriverEmailVerificationScreen(isSignUp: true),
      );
    }
  }

  void confirmPersonalInformation(BuildContext context) {
    if (!_validation.validateForm(confirmInfoFormKey)) return;
    _updateRegistrationStep2();
    NavigationUtility.slideRight(
      context,
      const DriverLicenseInformationScreen(),
    );
  }

  void confirmLicenseInformation(BuildContext context) {
    if (!_validation.validateForm(licenseInfoFormKey)) return;
    _updateRegistrationStep3();
    NavigationUtility.slideRight(context, const VehiclesInformationScreen());
  }

  void confirmVehicleInformation(BuildContext context) {
    if (!_validation.validateForm(vehicleInfoFormKey)) return;
    _updateRegistrationStep4();
    completeRegistration(context);
  }

  // Date picker methods - delegated to UI helpers
  Future<void> selectDateOfBirth(BuildContext context) async {
    final picked = await _uiHelpers.showDateOfBirthPicker(context);
    if (picked != null) {
      dateOfBirthController.text = _uiHelpers.formatDate(picked);
    }
  }

  Future<void> selectLicenseExpiryDate(BuildContext context) async {
    final picked = await _uiHelpers.showLicenseExpiryDatePicker(context);
    if (picked != null) {
      licenseExpiryDateController.text = _uiHelpers.formatDate(picked);
    }
  }

  // Selection methods - delegated to UI helpers
  void showGenderSelectionSheet(BuildContext context) =>
      _uiHelpers.showSelectionSheet(
        context,
        DriverSignUpConstants.genderOptions,
        genderController,
      );

  void showVehicleCategorySelectionSheet(BuildContext context) =>
      _uiHelpers.showSelectionSheet(
        context,
        DriverSignUpConstants.vehicleCategories,
        vehicleCategoryController,
      );

  // Image selection methods
  void uploadProfilePicture() =>
      _controllers.setProfileImage('dummy_profile_path');
  void selectLicenseImage() =>
      _controllers.setLicenseImage('dummy_license_path');
  void selectVehicleImage() =>
      _controllers.setVehicleImage('dummy_vehicle_path');

  // Registration completion
  Future<void> completeRegistration(BuildContext context) async {
    await executeTaskWithLoading(() async {
      final result = await _driverAuthRepository.signUp(currentUiState.driver!);

      await result.fold(
        (errorMessage) async => await addUserMessage(errorMessage),
        (user) async {
          _updateUiState(isRegistered: true);
          if (context.mounted) {
            _navigation.navigateWithFadeTransition(
              context,
              const AuthNavigator(),
              clearStack: true,
            );
          }
        },
      );
    });
  }

  // Reset password
  void resetPassword(BuildContext context) {
    if (!_validation.validateForm(resetPasswordFormKey)) return;
    _navigation.navigateWithSlideTransition(
      context,
      const AuthNavigator(),
      clearStack: true,
    );
  }

  // Private helper methods
  void _updateUiState({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isRegistered,
    DriverEntity? driver,
    int? currentStep,
  }) {
    uiState.value = currentUiState.copyWith(
      obscurePassword: obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword,
      isRegistered: isRegistered,
      driver: driver,
      currentStep: currentStep,
    );
  }

  Future<void> _updateRegistrationStep1() async {
    final driver = DriverEntity(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      contact: '01682015732',
      role: 'DRIVER',
      status: 'active',
      location: DriverLocation(lat: 0, lng: 0, address: ''),
    );

    final result = await _driverAuthRepository.signUp(driver);
    logError('result: $result');
    result.fold((errorMessage) async => await addUserMessage(errorMessage), (
      user,
    ) async {
      logError(user);
      _updateUiState(driver: driver, currentStep: 1);
    });
  }

  void _updateRegistrationStep2() {
    final updatedDriver = currentUiState.driver?.copyWith(
      contact: phoneNumberController.text.trim(),
      gender: genderController.text.trim(),
      dateOfBirth: DateTime.parse(dateOfBirthController.text.trim()),
      image: profileImagePath,
    );
    _updateUiState(driver: updatedDriver, currentStep: 2);
  }

  void _updateRegistrationStep3() {
    final updatedDriver = currentUiState.driver?.copyWith(
      driverLicense: DriverLicense(
        licenseNumber: int.parse(driverLicenseNumberController.text.trim()),
        licenseExpiryDate: DateTime.parse(
          licenseExpiryDateController.text.trim(),
        ),
        uploadDriversLicense: licenseImagePath ?? '',
      ),
    );
    _updateUiState(driver: updatedDriver, currentStep: 3);
  }

  void _updateRegistrationStep4() {
    final updatedDriver = currentUiState.driver?.copyWith(
      driverVehicles: DriverVehicle(
        vehiclesMake: vehiclesMakeController.text.trim(),
        vehiclesModel: vehiclesModelController.text.trim(),
        vehiclesYear: DateTime.parse(vehiclesYearController.text.trim()),
        vehiclesRegistrationNumber: int.parse(
          vehiclesRegistrationNumberController.text.trim(),
        ),
        vehiclesInsuranceNumber: int.parse(
          vehiclesInsuranceNumberController.text.trim(),
        ),
        vehiclesCategory: int.parse(vehicleCategoryController.text.trim()),
        vehiclesPicture: int.parse(vehicleImagePath ?? ''),
      ),
    );
    _updateUiState(driver: updatedDriver, currentStep: 4);
  }

  // BasePresenter overrides
  @override
  Future<void> addUserMessage(String message) async {
    _updateUiState(); // Trigger UI update with message
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    // Implementation depends on your UI state structure
    // uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }
}
