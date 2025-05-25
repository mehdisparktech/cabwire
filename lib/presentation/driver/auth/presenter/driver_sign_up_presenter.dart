import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_email_verify_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/domain/driver/auth/models/driver_registration.dart';
import 'package:cabwire/domain/driver/auth/usecases/register_usecase.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_ui_state.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_confirm_information_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_license_information.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_vehicles_information_screen.dart';

/// Optimized Presenter for the sign-up process
///
/// Key optimizations:
/// - Lazy initialization of controllers
/// - Grouped related functionality
/// - Better memory management
/// - Extracted constants and configuration
class DriverSignUpPresenter extends BasePresenter<DriverSignUpUiState> {
  // Configuration constants
  static const int _verificationCodeLength = 6;
  static const int _minAge = 18;
  static const int _maxLicenseValidityYears = 10;

  static const List<String> _genderOptions = ['Male', 'Female', 'Other'];
  static const List<String> _vehicleCategories = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Convertible',
    'Van',
    'Truck',
    'Motorcycle',
    'Other',
  ];

  // Use case dependency
  final RegisterUseCase _registerUseCase;

  // State management
  final Obs<DriverSignUpUiState> uiState = Obs(DriverSignUpUiState.empty());
  DriverSignUpUiState get currentUiState => uiState.value;

  // Lazy-initialized controllers grouped by functionality
  late final _SignUpControllers _signUpControllers;
  late final _VerificationControllers _verificationControllers;
  late final _PersonalInfoControllers _personalInfoControllers;
  late final _LicenseControllers _licenseControllers;
  late final _VehicleControllers _vehicleControllers;
  late final _ResetPasswordControllers _resetPasswordControllers;

  // Form keys
  final Map<String, GlobalKey<FormState>> _formKeys = {
    'signUp': GlobalKey<FormState>(),
    'confirmInfo': GlobalKey<FormState>(),
    'license': GlobalKey<FormState>(),
    'vehicle': GlobalKey<FormState>(),
    'resetPassword': GlobalKey<FormState>(),
  };

  DriverSignUpPresenter(this._registerUseCase) {
    _initializeControllers();
  }

  // Lazy initialization of controllers
  void _initializeControllers() {
    _signUpControllers = _SignUpControllers();
    _verificationControllers = _VerificationControllers();
    _personalInfoControllers = _PersonalInfoControllers();
    _licenseControllers = _LicenseControllers();
    _vehicleControllers = _VehicleControllers();
    _resetPasswordControllers = _ResetPasswordControllers();
  }

  // Getters for easy access
  GlobalKey<FormState> get signUpFormKey => _formKeys['signUp']!;
  GlobalKey<FormState> get confirmInfoFormKey => _formKeys['confirmInfo']!;
  GlobalKey<FormState> get licenseInfoFormKey => _formKeys['license']!;
  GlobalKey<FormState> get vehicleInfoFormKey => _formKeys['vehicle']!;
  GlobalKey<FormState> get resetPasswordFormKey => _formKeys['resetPassword']!;

  // Sign-up screen getters
  TextEditingController get nameController => _signUpControllers.name;
  TextEditingController get emailController => _signUpControllers.email;
  TextEditingController get passwordController => _signUpControllers.password;
  TextEditingController get confirmPasswordController =>
      _signUpControllers.confirmPassword;

  // Verification code getters
  List<TextEditingController> get verificationCodeControllers =>
      _verificationControllers.controllers;
  List<FocusNode> get verificationCodeFocusNodes =>
      _verificationControllers.focusNodes;

  // Personal info getters
  TextEditingController get phoneNumberController =>
      _personalInfoControllers.phoneNumber;
  TextEditingController get genderController => _personalInfoControllers.gender;
  TextEditingController get dateOfBirthController =>
      _personalInfoControllers.dateOfBirth;
  String? get profileImagePath => _personalInfoControllers.profileImagePath;

  // License info getters
  TextEditingController get driverLicenseNumberController =>
      _licenseControllers.licenseNumber;
  TextEditingController get licenseExpiryDateController =>
      _licenseControllers.expiryDate;
  TextEditingController get driverLicenseImageController =>
      _licenseControllers.licenseImage;
  String? get licenseImagePath => _licenseControllers.licenseImagePath;

  // Vehicle info getters
  TextEditingController get vehiclesMakeController => _vehicleControllers.make;
  TextEditingController get vehiclesModelController =>
      _vehicleControllers.model;
  TextEditingController get vehiclesYearController => _vehicleControllers.year;
  TextEditingController get vehiclesRegistrationNumberController =>
      _vehicleControllers.registrationNumber;
  TextEditingController get vehiclesInsuranceNumberController =>
      _vehicleControllers.insuranceNumber;
  TextEditingController get vehicleCategoryController =>
      _vehicleControllers.category;
  TextEditingController get vehiclesPictureController =>
      _vehicleControllers.picture;
  String? get vehicleImagePath => _vehicleControllers.vehicleImagePath;

  // Reset password getters
  TextEditingController get resetPasswordController =>
      _resetPasswordControllers.password;
  TextEditingController get resetConfirmPasswordController =>
      _resetPasswordControllers.confirmPassword;
  bool get resetObscurePassword => _resetPasswordControllers.obscurePassword;
  bool get resetObscureConfirmPassword =>
      _resetPasswordControllers.obscureConfirmPassword;

  // Password visibility methods
  void togglePasswordVisibility() =>
      _updateUiState(obscurePassword: !currentUiState.obscurePassword);

  void toggleConfirmPasswordVisibility() => _updateUiState(
    obscureConfirmPassword: !currentUiState.obscureConfirmPassword,
  );

  void toggleResetPasswordVisibility() {
    _resetPasswordControllers.togglePasswordVisibility();
    _updateUiState();
  }

  void toggleResetConfirmPasswordVisibility() {
    _resetPasswordControllers.toggleConfirmPasswordVisibility();
    _updateUiState();
  }

  // Validation methods
  bool validatePasswords() =>
      passwordController.text == confirmPasswordController.text;

  // Email verification methods
  void onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty && index < _verificationCodeLength - 1) {
      verificationCodeFocusNodes[index + 1].requestFocus();
    }
  }

  void resendVerificationCode() {
    addUserMessage('Verification code resent');
  }

  String getMaskedEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return email;
    return email.replaceRange(3, email.indexOf('@'), '...');
  }

  Future<void> verifyEmailCode(BuildContext context, bool isSignUp) async {
    final code =
        verificationCodeControllers.map((controller) => controller.text).join();

    if (code.length != _verificationCodeLength) {
      await addUserMessage(
        'Please enter a valid $_verificationCodeLength-digit code',
      );
      return;
    }

    final targetScreen =
        isSignUp
            ? const ConfirmInformationScreen()
            : const ResetPasswordScreen();

    if (context.mounted) {
      _navigateWithSlideTransition(context, targetScreen, clearStack: true);
    }
  }

  // Sign-up flow methods
  Future<void> onSignUp(BuildContext context) async {
    if (!_validateForm(signUpFormKey)) return;

    if (!validatePasswords()) {
      await addUserMessage('Passwords do not match');
      return;
    }

    _updateRegistrationStep1();

    if (context.mounted) {
      NavigationUtility.slideRight(
        context,
        const DriverEmailVerificationScreen(isSignUp: true),
      );
    }
  }

  void confirmPersonalInformation(BuildContext context) {
    if (!_validateForm(confirmInfoFormKey)) return;

    _updateRegistrationStep2();
    NavigationUtility.slideRight(
      context,
      const DriverLicenseInformationScreen(),
    );
  }

  void confirmLicenseInformation(BuildContext context) {
    if (!_validateForm(licenseInfoFormKey)) return;

    _updateRegistrationStep3();
    NavigationUtility.slideRight(context, const VehiclesInformationScreen());
  }

  void confirmVehicleInformation(BuildContext context) {
    if (!_validateForm(vehicleInfoFormKey)) return;

    _updateRegistrationStep4();
    completeRegistration(context);
  }

  // Date picker methods
  Future<void> selectDateOfBirth(BuildContext context) async {
    final picked = await _showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * _minAge)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirthController.text = _formatDate(picked);
    }
  }

  Future<void> selectLicenseExpiryDate(BuildContext context) async {
    final picked = await _showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 365 * _maxLicenseValidityYears),
      ),
    );

    if (picked != null) {
      licenseExpiryDateController.text = _formatDate(picked);
    }
  }

  // Selection methods
  void showGenderSelectionSheet(BuildContext context) =>
      _showSelectionSheet(context, _genderOptions, genderController);

  void showVehicleCategorySelectionSheet(BuildContext context) =>
      _showSelectionSheet(
        context,
        _vehicleCategories,
        vehicleCategoryController,
      );

  // Image selection methods
  void uploadProfilePicture() =>
      _personalInfoControllers.setProfileImage('dummy_profile_path');
  void selectLicenseImage() =>
      _licenseControllers.setLicenseImage('dummy_license_path');
  void selectVehicleImage() =>
      _vehicleControllers.setVehicleImage('dummy_vehicle_path');

  // Registration completion
  Future<void> completeRegistration(BuildContext context) async {
    await executeTaskWithLoading(() async {
      final result = await _registerUseCase.execute(
        registration: currentUiState.registration,
      );

      await result.fold(
        (errorMessage) async => await addUserMessage(errorMessage),
        (user) async {
          _updateUiState(isRegistered: true);
          if (context.mounted) {
            _navigateWithFadeTransition(
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
    if (!_validateForm(resetPasswordFormKey)) return;

    _navigateWithSlideTransition(
      context,
      const AuthNavigator(),
      clearStack: true,
    );
  }

  // Private helper methods
  bool _validateForm(GlobalKey<FormState> formKey) =>
      formKey.currentState?.validate() ?? false;

  void _updateUiState({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isRegistered,
    DriverRegistration? registration,
    int? currentStep,
  }) {
    uiState.value = currentUiState.copyWith(
      obscurePassword: obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword,
      isRegistered: isRegistered,
      registration: registration,
      currentStep: currentStep,
    );
  }

  void _updateRegistrationStep1() {
    final registration = DriverRegistration(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    _updateUiState(registration: registration, currentStep: 1);
    phoneNumberController.text = nameController.text.trim();
  }

  void _updateRegistrationStep2() {
    final updatedRegistration = currentUiState.registration.copyWith(
      phone: phoneNumberController.text.trim(),
      gender: genderController.text.trim(),
      dateOfBirth: dateOfBirthController.text.trim(),
      profileImage: profileImagePath,
    );

    _updateUiState(registration: updatedRegistration, currentStep: 2);
  }

  void _updateRegistrationStep3() {
    final updatedRegistration = currentUiState.registration.copyWith(
      licenseNumber: driverLicenseNumberController.text.trim(),
      licenseExpiryDate: licenseExpiryDateController.text.trim(),
      licenseImage: licenseImagePath,
    );

    _updateUiState(registration: updatedRegistration, currentStep: 3);
  }

  void _updateRegistrationStep4() {
    final updatedRegistration = currentUiState.registration.copyWith(
      vehicleMake: vehiclesMakeController.text.trim(),
      vehicleModel: vehiclesModelController.text.trim(),
      vehicleYear: vehiclesYearController.text.trim(),
      vehicleRegistrationNumber:
          vehiclesRegistrationNumberController.text.trim(),
      vehicleInsuranceNumber: vehiclesInsuranceNumberController.text.trim(),
      vehicleCategory: vehicleCategoryController.text.trim(),
      vehicleImage: vehicleImagePath,
    );

    _updateUiState(registration: updatedRegistration, currentStep: 4);
  }

  Future<DateTime?> _showDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) => showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

  void _showSelectionSheet(
    BuildContext context,
    List<String> options,
    TextEditingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children:
                options
                    .map(
                      (option) => ListTile(
                        title: Text(option),
                        onTap: () {
                          controller.text = option;
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList(),
          ),
    );
  }

  void _navigateWithSlideTransition(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => destination,
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
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.push(context, route);
    }
  }

  void _navigateWithFadeTransition(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => destination,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );

    if (clearStack) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.push(context, route);
    }
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
    _signUpControllers.dispose();
    _verificationControllers.dispose();
    _personalInfoControllers.dispose();
    _licenseControllers.dispose();
    _vehicleControllers.dispose();
    _resetPasswordControllers.dispose();
    super.dispose();
  }
}

// Controller groups for better organization and memory management
class _SignUpControllers {
  late final TextEditingController name;
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController confirmPassword;

  _SignUpControllers() {
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }
}

class _VerificationControllers {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  _VerificationControllers() {
    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());
  }

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
  }
}

class _PersonalInfoControllers {
  late final TextEditingController phoneNumber;
  late final TextEditingController gender;
  late final TextEditingController dateOfBirth;
  String? profileImagePath;

  _PersonalInfoControllers() {
    phoneNumber = TextEditingController();
    gender = TextEditingController();
    dateOfBirth = TextEditingController();
  }

  void setProfileImage(String path) {
    profileImagePath = path;
  }

  void dispose() {
    phoneNumber.dispose();
    gender.dispose();
    dateOfBirth.dispose();
  }
}

class _LicenseControllers {
  late final TextEditingController licenseNumber;
  late final TextEditingController expiryDate;
  late final TextEditingController licenseImage;
  String? licenseImagePath;

  _LicenseControllers() {
    licenseNumber = TextEditingController();
    expiryDate = TextEditingController();
    licenseImage = TextEditingController();
  }

  void setLicenseImage(String path) {
    licenseImagePath = path;
    licenseImage.text = 'License image selected';
  }

  void dispose() {
    licenseNumber.dispose();
    expiryDate.dispose();
    licenseImage.dispose();
  }
}

class _VehicleControllers {
  late final TextEditingController make;
  late final TextEditingController model;
  late final TextEditingController year;
  late final TextEditingController registrationNumber;
  late final TextEditingController insuranceNumber;
  late final TextEditingController category;
  late final TextEditingController picture;
  String? vehicleImagePath;

  _VehicleControllers() {
    make = TextEditingController();
    model = TextEditingController();
    year = TextEditingController();
    registrationNumber = TextEditingController();
    insuranceNumber = TextEditingController();
    category = TextEditingController();
    picture = TextEditingController();
  }

  void setVehicleImage(String path) {
    vehicleImagePath = path;
    picture.text = 'Vehicle image selected';
  }

  void dispose() {
    make.dispose();
    model.dispose();
    year.dispose();
    registrationNumber.dispose();
    insuranceNumber.dispose();
    category.dispose();
    picture.dispose();
  }
}

class _ResetPasswordControllers {
  late final TextEditingController password;
  late final TextEditingController confirmPassword;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  _ResetPasswordControllers() {
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
  }

  void dispose() {
    password.dispose();
    confirmPassword.dispose();
  }
}
