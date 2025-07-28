import 'dart:async';
import 'dart:io';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/app_assets.dart'; // For default assets
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/domain/usecases/driver/driver_contact_usecase.dart';
import 'package:cabwire/domain/usecases/driver/delete_profile_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_profile_update_usecase.dart';
import 'package:cabwire/domain/usecases/privacy_and_policy_usecase.dart';
import 'package:cabwire/domain/usecases/terms_and_conditions_usecase.dart';
import 'package:cabwire/presentation/common/screens/splash/ui/welcome_screen.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_ui_state.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/contact_us_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_driving_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_password_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_profile_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_vehicle_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/privacy_policy_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/terms_and_conditions_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/widgets/delete_account_dialog.dart';
import 'package:cabwire/presentation/driver/profile/ui/widgets/logout_dialog.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/screens/ride_history_page.dart';
// import 'package:cabwire/features/auth/ui/login_screen.dart'; // For navigation after logout/delete
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart'; // If you implement image picking

class DriverProfilePresenter extends BasePresenter<DriverProfileUiState> {
  final TermsAndConditionsUsecase _termsAndConditionsUsecase;
  final PrivacyAndPolicyUsecase _privacyAndPolicyUsecase;
  final DriverDeleteProfileUsecase _deleteProfileUsecase;
  final DriverProfileUpdateUsecase _updateProfileUsecase;
  final Obs<DriverProfileUiState> uiState = Obs<DriverProfileUiState>(
    DriverProfileUiState.initial(),
  );
  DriverProfileUiState get currentUiState => uiState.value;

  // Use cases
  final DriverContactUseCase _driverContactUseCase;

  // --- Text Editing Controllers for Forms ---
  // Edit Profile Info
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editEmailController = TextEditingController();
  final TextEditingController editPhoneNumberController =
      TextEditingController();
  final TextEditingController editDobController =
      TextEditingController(); // Date of Birth
  final TextEditingController editGenderController = TextEditingController();
  File? selectedProfileImageFile; // For new profile image

  // Edit Password
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  // Edit Driving Info
  final TextEditingController drivingLicenseNumberController =
      TextEditingController();
  final TextEditingController drivingLicenseExpiryDateController =
      TextEditingController();
  final TextEditingController drivingLicenseIssuingDateController =
      TextEditingController();
  final TextEditingController vehiclesRegistrationNumberController =
      TextEditingController();
  final TextEditingController vehiclesInsuranceNumberController =
      TextEditingController();
  final TextEditingController vehiclesMakeController = TextEditingController();
  final TextEditingController vehiclesModelController = TextEditingController();
  final TextEditingController vehiclesYearController = TextEditingController();
  final TextEditingController vehiclesCategoryController =
      TextEditingController();
  // Add controllers for other driving info fields if any

  // Contact Us
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneNumberController =
      TextEditingController();
  final TextEditingController contactMessageController =
      TextEditingController();
  final TextEditingController contactSubjectController =
      TextEditingController();

  // Delete Account
  final TextEditingController deleteAccountPasswordController =
      TextEditingController();

  DriverProfilePresenter(
    this._driverContactUseCase,
    this._termsAndConditionsUsecase,
    this._privacyAndPolicyUsecase,
    this._deleteProfileUsecase,
    this._updateProfileUsecase,
  ) {
    loadDriverProfile();
    _loadInitialData();
    getTermsAndConditions();
    getPrivacyPolicy();
  }

  Future<void> loadDriverProfile() async {
    try {
      final DriverProfileModel? profile = await LocalStorage.getDriverProfile();
      if (profile != null) {
        uiState.value = currentUiState.copyWith(
          userProfile: UserProfileData(
            name: profile.name ?? '',
            email: profile.email ?? '',
            phoneNumber: profile.contact ?? '01823450011',
            avatarUrl: AppAssets.icProfileImage,
            dateOfBirth: profile.dateOfBirth ?? '1994-11-15',
            gender: profile.gender ?? 'Male',
          ),
        );
      }
    } catch (e) {
      logError('Error loading driver profile: $e');
    }
  }

  Future<void> _loadInitialData() async {
    toggleLoading(loading: true);
    // Simulate fetching user profile and driving info
    await Future.delayed(const Duration(seconds: 1));
    final DriverProfileModel? profile = await LocalStorage.getDriverProfile();

    final fetchedDrivingInfo = DrivingInfoData(
      licenseNumber:
          profile?.driverLicense?.licenseNumber.toString() ?? '22222222',
      licenseExpiryDate:
          profile?.driverLicense?.licenseExpiryDate.toString().split('T')[0] ??
          '2025-01-01',
      licenseIssueDate: '2023-01-01',
      vehiclesRegistrationNumber:
          profile?.driverVehicles?.vehiclesRegistrationNumber.toString() ??
          '123456789',
      vehiclesInsuranceNumber:
          profile?.driverVehicles?.vehiclesInsuranceNumber.toString() ??
          '333333333',
      vehiclesMake: profile?.driverVehicles?.vehiclesMake ?? 'Toyota',
      vehiclesModel: profile?.driverVehicles?.vehiclesModel ?? 'Civic',
      vehiclesYear:
          profile?.driverVehicles?.vehiclesYear.toString().split('T')[0] ??
          '2020',
      vehiclesCategory: profile?.driverVehicles?.vehiclesCategory ?? 'Sedan',
    );

    uiState.value = currentUiState.copyWith(drivingInfo: fetchedDrivingInfo);

    // Initialize controllers for edit forms with fetched data
    _populateEditProfileControllers(currentUiState.userProfile);
    _populateEditDrivingControllers(fetchedDrivingInfo);

    toggleLoading(loading: false);
  }

  void _populateEditProfileControllers(UserProfileData profile) {
    editNameController.text = profile.name;
    editEmailController.text = profile.email;
    editPhoneNumberController.text = profile.phoneNumber;
    editDobController.text = profile.dateOfBirth ?? '';
    editGenderController.text = profile.gender ?? '';
  }

  void _populateEditDrivingControllers(DrivingInfoData info) {
    drivingLicenseNumberController.text = info.licenseNumber;
    drivingLicenseExpiryDateController.text = info.licenseExpiryDate;
    drivingLicenseIssuingDateController.text = info.licenseIssueDate;
    vehiclesRegistrationNumberController.text = info.vehiclesRegistrationNumber;
    vehiclesInsuranceNumberController.text = info.vehiclesInsuranceNumber;
    vehiclesMakeController.text = info.vehiclesMake;
    vehiclesModelController.text = info.vehiclesModel;
    vehiclesYearController.text = info.vehiclesYear;
    vehiclesCategoryController.text = info.vehiclesCategory;
  }

  @override
  Future<void> addUserMessage(String message, {bool isError = false}) async {
    // Added isError
    uiState.value = currentUiState.copyWith(userMessage: message);
    // Optionally, use your BasePresenter's showMessage or a snackbar service
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  // --- Navigation Methods ---
  void navigateToEditProfile() {
    _populateEditProfileControllers(
      currentUiState.userProfile,
    ); // Ensure controllers have latest data
    selectedProfileImageFile = null; // Reset selected image
    Get.to(() => EditProfileInfoScreen());
  }

  void navigateToEditPassword() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    Get.to(() => EditPasswordScreen());
  }

  void navigateToEditDrivingInfo() {
    _populateEditDrivingControllers(
      currentUiState.drivingInfo,
    ); // Ensure controllers have latest data
    Get.to(() => EditDrivingInfoScreen());
  }

  void navigateToEditVehicleInfo() {
    _populateEditDrivingControllers(currentUiState.drivingInfo);
    Get.to(() => EditVehicleInfoScreen());
  }

  void navigateToHistory() {
    Get.to(() => RideHistoryPage());
  }

  void navigateToTermsAndConditions() {
    Get.to(() => TermsAndConditionsScreen());
  }

  void navigateToPrivacyPolicy() {
    Get.to(() => PrivacyPolicyScreen());
  }

  void navigateToContactUs() {
    contactNameController.text = currentUiState.userProfile.name; // Pre-fill
    contactEmailController.text = currentUiState.userProfile.email; // Pre-fill
    contactPhoneNumberController.clear();
    contactMessageController.clear();
    Get.to(() => ContactUsScreen());
  }

  // --- Dialog Triggers ---
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => DeleteAccountDialog(
            onConfirm: () {
              Get.back(); // Close dialog
            },
            presenter: this,
          ),
    );
  }

  void toggleShowPassword() {
    uiState.value = currentUiState.copyWith(
      showPassword: !(currentUiState.showPassword ?? false),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => LogoutDialog(
            onConfirm: () {
              Get.back(); // Close dialog
              _logoutUser();
            },
          ),
    );
  }

  // --- Actions ---
  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedProfileImageFile = File(image.path);
      addUserMessage("Image selected. Press Save to upload.");
      uiState.value = currentUiState.copyWith(
        userMessage: uiState.value.userMessage,
      );
    }
  }

  Future<void> saveProfileInfo() async {
    toggleLoading(loading: true);
    // Validate form fields (basic example)
    if (editNameController.text.isEmpty || editEmailController.text.isEmpty) {
      addUserMessage("Name and Email cannot be empty.", isError: true);
      toggleLoading(loading: false);
      return;
    }
    // Simulate API call to update profile
    final result = await _updateProfileUsecase.execute(
      editNameController.text,
      editPhoneNumberController.text,
      selectedProfileImageFile?.path,
    );
    result.fold(
      (error) {
        toggleLoading(loading: false);
        addUserMessage(error, isError: true);
        return;
      },
      (success) {
        toggleLoading(loading: false);
        addUserMessage(success);
      },
    );
    // On success, update the main userProfile state
    final updatedProfile = currentUiState.userProfile.copyWith(
      name: editNameController.text,
      email: editEmailController.text,
      phoneNumber: editPhoneNumberController.text,
      dateOfBirth: editDobController.text,
      gender: editGenderController.text,
      // avatarUrl: newImageUrlFromServerIfUploaded, // Update if image was uploaded
    );
    uiState.value = currentUiState.copyWith(
      userProfile: updatedProfile,
      isLoading: false,
    );
    addUserMessage("Profile updated successfully!");
    showMessage(message: 'Profile updated successfully!');
    Get.back(); // Go back from edit screen
  }

  Future<void> savePassword() async {
    if (newPasswordController.text != confirmNewPasswordController.text) {
      addUserMessage("New passwords do not match.", isError: true);
      return;
    }
    if (newPasswordController.text.length < 6) {
      addUserMessage(
        "New password must be at least 6 characters.",
        isError: true,
      );
      return;
    }
    toggleLoading(loading: true);
    // Simulate API call
    appLog(
      "Changing password. Old: ${oldPasswordController.text}, New: ${newPasswordController.text}",
    );
    await Future.delayed(const Duration(seconds: 2));
    // Assume success
    toggleLoading(loading: false);
    addUserMessage("Password changed successfully!");
    Get.back();
  }

  Future<void> saveDrivingInfo() async {
    toggleLoading(loading: true);
    // Simulate API call
    appLog("Saving driving info: ${drivingLicenseNumberController.text}");
    await Future.delayed(const Duration(seconds: 2));
    final updatedDrivingInfo = currentUiState.drivingInfo.copyWith(
      licenseNumber: drivingLicenseNumberController.text,
      licenseExpiryDate: drivingLicenseExpiryDateController.text,
      licenseIssueDate: drivingLicenseIssuingDateController.text,
    );
    uiState.value = currentUiState.copyWith(
      drivingInfo: updatedDrivingInfo,
      isLoading: false,
    );
    addUserMessage("Driving information updated successfully!");
    showMessage(message: 'Driving information updated successfully!');
    Get.back();
  }

  Future<void> submitContactUsForm() async {
    if (contactMessageController.text.isEmpty) {
      addUserMessage("Message cannot be empty.", isError: true);
      return;
    }
    if (contactNameController.text.isEmpty) {
      addUserMessage("Name cannot be empty.", isError: true);
      return;
    }
    if (contactEmailController.text.isEmpty) {
      addUserMessage("Email cannot be empty.", isError: true);
      return;
    }
    if (contactSubjectController.text.isEmpty) {
      addUserMessage("Subject cannot be empty.", isError: true);
      return;
    }

    toggleLoading(loading: true);

    final params = DriverContactParams(
      fullName: contactNameController.text,
      email: contactEmailController.text,
      phone: contactPhoneNumberController.text,
      subject: contactSubjectController.text,
      description: contactMessageController.text,
      status: true,
    );

    final result = await _driverContactUseCase(params);

    result.fold(
      (error) {
        toggleLoading(loading: false);
        addUserMessage("Failed to send message: $error", isError: true);
      },
      (_) {
        toggleLoading(loading: false);
        addUserMessage("Your message has been sent!");
        _clearContactForm();
        Get.back();
      },
    );
  }

  void _clearContactForm() {
    contactNameController.clear();
    contactEmailController.clear();
    contactPhoneNumberController.clear();
    contactSubjectController.clear();
    contactMessageController.clear();
  }

  void _logoutUser() {
    toggleLoading(loading: true);
    // Perform actual logout (clear tokens, user data)
    appLog("Logging out user...");
    LocalStorage.removeAllPrefData();
    Future.delayed(const Duration(seconds: 1), () {
      toggleLoading(loading: false);
      // GetNavigation.Get.offAll(() => LoginScreen()); // Navigate to login
      Get.offAll(() => DriverAuthNavigatorScreen());
      addUserMessage("Logged out successfully");
    });
  }

  Future<void> deleteAccount(String password) async {
    toggleLoading(loading: true);
    try {
      final result = await _deleteProfileUsecase.execute(password);
      result.fold(
        (error) {
          addUserMessage(error, isError: true);
          toggleLoading(loading: false);
          return;
        },
        (success) {
          addUserMessage(success);
          LocalStorage.removeAllPrefData();
          toggleLoading(loading: false);
          Get.offAll(() => WelcomeScreen());
        },
      );
    } catch (e) {
      addUserMessage(e.toString(), isError: true);
      toggleLoading(loading: false);
    }
  }

  void goBack() {
    Get.back();
  }

  Future<void> getTermsAndConditions() async {
    final result = await _termsAndConditionsUsecase.execute(forType: 'driver');
    result.fold(
      (error) {
        addUserMessage(
          "Failed to get terms and conditions: $error",
          isError: true,
        );
      },
      (termsAndConditions) {
        appLog("Terms and conditions: $termsAndConditions");
        uiState.value = currentUiState.copyWith(
          termsAndConditions: termsAndConditions,
        );
      },
    );
  }

  Future<void> getPrivacyPolicy() async {
    final result = await _privacyAndPolicyUsecase.execute(forType: 'driver');
    result.fold(
      (error) {
        addUserMessage("Failed to get privacy policy: $error", isError: true);
      },
      (privacyPolicy) {
        appLog("Privacy policy: $privacyPolicy");
        uiState.value = currentUiState.copyWith(privacyPolicy: privacyPolicy);
      },
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    editNameController.dispose();
    editEmailController.dispose();
    editPhoneNumberController.dispose();
    editDobController.dispose();
    editGenderController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    drivingLicenseNumberController.dispose();
    drivingLicenseExpiryDateController.dispose();
    drivingLicenseIssuingDateController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactPhoneNumberController.dispose();
    contactMessageController.dispose();
    contactSubjectController.dispose();
    deleteAccountPasswordController.dispose();
    super.dispose();
  }
}
