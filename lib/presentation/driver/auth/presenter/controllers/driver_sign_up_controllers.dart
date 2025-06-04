import 'package:flutter/material.dart';

class DriverSignUpControllers {
  // Form keys
  final Map<String, GlobalKey<FormState>> _formKeys = {
    'signUp': GlobalKey<FormState>(),
    'confirmInfo': GlobalKey<FormState>(),
    'license': GlobalKey<FormState>(),
    'vehicle': GlobalKey<FormState>(),
    'resetPassword': GlobalKey<FormState>(),
  };

  // Controller groups
  late final _SignUpControllers _signUpControllers;
  late final _VerificationControllers _verificationControllers;
  late final _PersonalInfoControllers _personalInfoControllers;
  late final _LicenseControllers _licenseControllers;
  late final _VehicleControllers _vehicleControllers;
  late final _ResetPasswordControllers _resetPasswordControllers;

  DriverSignUpControllers() {
    _initializeControllers();
  }

  void _initializeControllers() {
    _signUpControllers = _SignUpControllers();
    _verificationControllers = _VerificationControllers();
    _personalInfoControllers = _PersonalInfoControllers();
    _licenseControllers = _LicenseControllers();
    _vehicleControllers = _VehicleControllers();
    _resetPasswordControllers = _ResetPasswordControllers();
  }

  // Form key getters
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

  // Image setter methods
  void setProfileImage(String path) =>
      _personalInfoControllers.setProfileImage(path);
  void setLicenseImage(String path) =>
      _licenseControllers.setLicenseImage(path);
  void setVehicleImage(String path) =>
      _vehicleControllers.setVehicleImage(path);

  // Reset password visibility methods
  void toggleResetPasswordVisibility() =>
      _resetPasswordControllers.togglePasswordVisibility();
  void toggleResetConfirmPasswordVisibility() =>
      _resetPasswordControllers.toggleConfirmPasswordVisibility();

  void dispose() {
    _signUpControllers.dispose();
    _verificationControllers.dispose();
    _personalInfoControllers.dispose();
    _licenseControllers.dispose();
    _vehicleControllers.dispose();
    _resetPasswordControllers.dispose();
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
