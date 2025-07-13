import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart'
    as driver_entity;
import 'package:cabwire/domain/entities/driver/driver_profile_entity.dart'
    as profile_entity;
import 'package:cabwire/domain/usecases/driver/driver_profile_update_usecase.dart';
import 'package:cabwire/domain/usecases/driver/resent_code_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_sign_up_usecase.dart';
import 'package:cabwire/domain/usecases/driver/verify_email_usecase.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_email_verification_presenter.dart';
import 'package:cabwire/presentation/driver/auth/presenter/driver_sign_up_resend_code.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_email_verify_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/core/utility/helpers/date_format_helper.dart';
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

class DriverSignUpPresenter extends BasePresenter<DriverSignUpUiState>
    implements DriverEmailVerificationPresenter {
  // Use case dependency
  // final DriverAuthRepository _driverAuthRepository;
  final VerifyEmailUsecase _verifyEmailUsecase;
  final ResentCodeUsecase _resentCodeUsecase;
  final DriverSignUpUseCase _signUpUsecase;
  final DriverProfileUpdateUsecase _driverProfileUpdateUsecase;

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

  // Resend code handler
  late final DriverResendCodeHandler _resendCodeHandler;

  DriverSignUpPresenter(
    // this._driverAuthRepository,
    this._verifyEmailUsecase,
    this._resentCodeUsecase,
    this._signUpUsecase,
    this._driverProfileUpdateUsecase,
  );

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
    _resendCodeHandler = DriverResendCodeHandler(
      resentCodeUsecase: _resentCodeUsecase,
    );
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
  @override
  TextEditingController get emailController => _controllers.emailController;
  TextEditingController get passwordController =>
      _controllers.passwordController;
  TextEditingController get confirmPasswordController =>
      _controllers.confirmPasswordController;

  @override
  List<TextEditingController> get verificationCodeControllers =>
      _controllers.verificationCodeControllers;
  @override
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
      currentUiState.copyWith(obscurePassword: !currentUiState.obscurePassword);
  void toggleConfirmPasswordVisibility() => currentUiState.copyWith(
    obscureConfirmPassword: !currentUiState.obscureConfirmPassword,
  );
  void toggleResetPasswordVisibility() {
    _controllers.toggleResetPasswordVisibility();
    currentUiState.copyWith();
  }

  void toggleResetConfirmPasswordVisibility() {
    _controllers.toggleResetConfirmPasswordVisibility();
    currentUiState.copyWith();
  }

  // Validation methods - delegated to validation helper
  bool validatePasswords() => _validation.validatePasswords(
    passwordController.text,
    confirmPasswordController.text,
  );

  // Email verification methods
  @override
  void onCodeDigitInput(int index, String value) {
    if (value.isNotEmpty &&
        index < DriverSignUpConstants.verificationCodeLength - 1) {
      verificationCodeFocusNodes[index + 1].requestFocus();
    }
  }

  // reset verification code

  // Future<void> resendVerificationCode() async {
  //   final result = await _resentCodeUsecase.execute(
  //     emailController.text.trim(),
  //   );
  //   result.fold(
  //     (errorMessage) async {
  //       await addUserMessage(errorMessage);
  //       await showMessage(message: errorMessage);
  //     },
  //     (message) async {
  //       await addUserMessage(message);
  //       await showMessage(message: message);
  //     },
  //   );
  //   await showMessage(message: result.fold((l) => l, (r) => r));
  // }

  //get masked email
  @override
  String getMaskedEmail(String email) => _validation.getMaskedEmail(email);

  //verify email code
  @override
  Future<void> verifyEmailCode(BuildContext context, bool isSignUp) async {
    final code =
        verificationCodeControllers.map((controller) => controller.text).join();
    debugPrint('code: $code');

    if (code.length != DriverSignUpConstants.verificationCodeLength) {
      await addUserMessage(
        'Please enter a valid ${DriverSignUpConstants.verificationCodeLength}-digit code',
      );
      return;
    }

    final result = await _verifyEmailUsecase.execute(
      emailController.text.trim(),
      code,
    );
    debugPrint('result: $result');
    result.fold((errorMessage) async => await addUserMessage(errorMessage), (
      data,
    ) async {
      await addUserMessage(data['message']);
      // currentUiState.copyWith(resetToken: data['data']);
    });

    if (result.isRight()) {
      final targetScreen =
          isSignUp
              ? const ConfirmInformationScreen()
              : const ResetPasswordScreen();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
          (route) => false,
        );
      }
    }
    await showMessage(message: result.fold((l) => l, (r) => r['message']));
  }

  // Sign-up flow methods
  Future<void> onSignUp(BuildContext context) async {
    if (!_validation.validateForm(signUpFormKey)) return;

    if (!validatePasswords()) {
      await addUserMessage('Passwords do not match');
      await showMessage(message: 'Passwords do not match');
      return;
    }

    await _updateRegistrationStep1(context);
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
  Future<void> uploadProfilePicture(BuildContext context) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      try {
        final pickedFile = await ImagePicker().pickImage(
          source: source,
          imageQuality: 70,
        );

        if (pickedFile != null) {
          _controllers.setProfileImage(pickedFile.path);
          uiState.value = currentUiState.copyWith();
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
        await showMessage(message: 'Failed to pick image: $e');
      }
    }
  }

  Future<void> selectLicenseImage(BuildContext context) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      try {
        final pickedFile = await ImagePicker().pickImage(
          source: source,
          imageQuality: 70,
        );

        if (pickedFile != null) {
          _controllers.setLicenseImage(pickedFile.path);
          uiState.value = currentUiState.copyWith();
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
        await showMessage(message: 'Failed to pick image: $e');
      }
    }
  }

  Future<void> selectVehicleImage(BuildContext context) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      try {
        final pickedFile = await ImagePicker().pickImage(
          source: source,
          imageQuality: 70,
        );

        if (pickedFile != null) {
          _controllers.setVehicleImage(pickedFile.path);
          uiState.value = currentUiState.copyWith();
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
        await showMessage(message: 'Failed to pick image: $e');
      }
    }
  }

  // Registration completion
  Future<void> completeRegistration(BuildContext context) async {
    await executeTaskWithLoading(() async {
      // Parse the display dates to DateTime objects
      final dateOfBirthDateTime = DateFormatHelper.parseDisplayDate(
        dateOfBirthController.text.trim(),
      );
      final licenseExpiryDateTime = DateFormatHelper.parseDisplayDate(
        licenseExpiryDateController.text.trim(),
      );

      if (dateOfBirthDateTime == null || licenseExpiryDateTime == null) {
        await addUserMessage('Invalid date format');
        return;
      }

      final profile = DriverProfileModel(
        name: nameController.text.trim(),
        contact: phoneNumberController.text.trim(),
        gender: genderController.text.trim(),
        dateOfBirth: DateFormatHelper.formatDateForApi(dateOfBirthDateTime),
        image: profileImagePath,
        driverLicense: profile_entity.DriverLicenseEntity(
          licenseNumber: int.parse(driverLicenseNumberController.text.trim()),
          licenseExpiryDate: DateFormatHelper.formatDateForApi(
            licenseExpiryDateTime,
          ),
          uploadDriversLicense: licenseImagePath ?? '',
        ),
        driverVehicles: profile_entity.DriverVehicleEntity(
          vehiclesMake: vehiclesMakeController.text.trim(),
          vehiclesModel: vehiclesModelController.text.trim(),
          vehiclesYear: vehiclesYearController.text.trim(),
          vehiclesRegistrationNumber: int.parse(
            vehiclesRegistrationNumberController.text.trim(),
          ),
          vehiclesInsuranceNumber: int.parse(
            vehiclesInsuranceNumberController.text.trim(),
          ),
          vehiclesCategory: 1,
          vehiclesPicture: vehicleImagePath,
        ),
      );
      final result = await _driverProfileUpdateUsecase.execute(
        profile,
        emailController.text.trim(),
      );

      await result.fold(
        (errorMessage) async => await addUserMessage(errorMessage),
        (user) async {
          currentUiState.copyWith(isRegistered: true);
          clearControllers();
          if (context.mounted) {
            _navigation.navigateWithFadeTransition(
              context,
              const DriverAuthNavigatorScreen(),
              clearStack: true,
            );
          }
        },
      );
    });
  }

  Future<void> _updateRegistrationStep1(BuildContext context) async {
    final driver = UserModel(
      name: nameController.text.trim(),
      role: 'DRIVER',
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    final result = await _signUpUsecase.call(driver);
    logError('result: $result');
    result.fold(
      (errorMessage) async {
        await addUserMessage(errorMessage);
        uiState.value = currentUiState.copyWith(currentStep: 0);
        await showMessage(message: errorMessage);
      },
      (user) async {
        logError(user);
        uiState.value = currentUiState.copyWith(user: user, currentStep: 1);
        await showMessage(message: 'send otp to ${user.data?.email}');
      },
    );
    if (result.isRight()) {
      debugPrint('currentUiState: ${currentUiState.user?.success}');
      if (context.mounted) {
        NavigationUtility.slideRight(
          context,
          const DriverEmailVerificationScreen(isSignUp: true),
        );
      }
    }
  }

  void _updateRegistrationStep2() {
    final updatedDriver = currentUiState.driver?.copyWith(
      contact: phoneNumberController.text.trim(),
      gender: genderController.text.trim(),
      dateOfBirth: DateTime.parse(dateOfBirthController.text.trim()),
      image: profileImagePath,
    );
    currentUiState.copyWith(driver: updatedDriver, currentStep: 2);
  }

  void _updateRegistrationStep3() {
    final updatedDriver = currentUiState.driver?.copyWith(
      driverLicense: driver_entity.DriverLicenseEntity(
        licenseNumber: int.parse(driverLicenseNumberController.text.trim()),
        licenseExpiryDate: DateTime.parse(
          licenseExpiryDateController.text.trim(),
        ),
        uploadDriversLicense: licenseImagePath ?? '',
      ),
    );
    currentUiState.copyWith(driver: updatedDriver, currentStep: 3);
  }

  void _updateRegistrationStep4() {
    final updatedDriver = currentUiState.driver?.copyWith(
      driverVehicles: driver_entity.DriverVehicleEntity(
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
        vehiclesPicture: int.parse(vehicleImagePath ?? '0'),
      ),
    );
    currentUiState.copyWith(driver: updatedDriver, currentStep: 4);
  }

  @override
  Future<void> resendVerificationCode() async {
    await _resendCodeHandler.resendCode(
      email: emailController.text,
      showMessage: (message) => showMessage(message: message),
      addUserMessage: addUserMessage,
    );
  }

  // BasePresenter overrides
  @override
  Future<void> addUserMessage(String message) async {
    currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    currentUiState.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    for (final c in verificationCodeControllers) {
      c.clear();
    }
    nameController.clear();
    phoneNumberController.clear();
    genderController.clear();
    dateOfBirthController.clear();
    driverLicenseNumberController.clear();
    licenseExpiryDateController.clear();
    driverLicenseImageController.clear();
    vehiclesMakeController.clear();
    vehiclesModelController.clear();
    vehiclesYearController.clear();
    vehiclesRegistrationNumberController.clear();
    vehiclesInsuranceNumberController.clear();
    vehicleCategoryController.clear();
    vehiclesPictureController.clear();
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
  }
}
