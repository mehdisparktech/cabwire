import 'dart:async';
import 'dart:io';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/app_assets.dart'; // For default assets
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/domain/usecases/driver/driver_contact_usecase.dart';
import 'package:cabwire/presentation/driver/auth/ui/screens/driver_auth_navigator_screen.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_ui_state.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/contact_us_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_driving_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_password_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/edit_profile_info_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/privacy_policy_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/screens/terms_and_conditions_screen.dart';
import 'package:cabwire/presentation/driver/profile/ui/widgets/delete_account_dialog.dart';
import 'package:cabwire/presentation/driver/profile/ui/widgets/logout_dialog.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/screens/ride_history_page.dart';
// import 'package:cabwire/features/auth/ui/login_screen.dart'; // For navigation after logout/delete
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
// import 'package:image_picker/image_picker.dart'; // If you implement image picking

class DriverProfilePresenter extends BasePresenter<DriverProfileUiState> {
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

  DriverProfilePresenter(this._driverContactUseCase) {
    loadDriverProfile();
    _loadInitialData();
  }

  Future<void> loadDriverProfile() async {
    try {
      final ProfileModel? profile = await LocalStorage.getDriverProfile();
      if (profile != null) {
        uiState.value = currentUiState.copyWith(
          userProfile: UserProfileData(
            name: profile.name ?? '',
            email: profile.email ?? '',
            phoneNumber: '01625815151',
            avatarUrl: AppAssets.icProfileImage,
            dateOfBirth: '1990-01-01',
            gender: 'Male',
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

    // Populate with fetched data
    // final fetchedUserProfile = UserProfileData(
    //   name: 'John Doe',
    //   email: 'john.doe@example.com',
    //   phoneNumber: '1234567890',
    //   avatarUrl: AppAssets.icProfileImage, // Placeholder or actual URL
    //   dateOfBirth: '1990-01-01',
    //   gender: 'Male',
    // );

    final fetchedDrivingInfo = DrivingInfoData(
      licenseNumber: 'DL12345XYZ',
      licenseExpiryDate: '2028-12-31',
      licenseIssueDate: '2018-01-01',
      vehiclesRegistrationNumber: '1234567890',
      vehiclesInsuranceNumber: '1234567890',
      vehiclesMake: 'Toyota',
      vehiclesModel: 'Corolla',
      vehiclesYear: '2020',
      vehiclesCategory: 'Car',
    );

    uiState.value = currentUiState.copyWith(
      //userProfile: fetchedUserProfile,
      drivingInfo: fetchedDrivingInfo,
    );

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
              _deleteAccount();
            },
          ),
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
    // // Using image_picker package
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   selectedProfileImageFile = File(image.path);
    //   // To show preview immediately, you might need a separate observable for the image file in UI state
    //   // or trigger a rebuild of the EditProfileInfoScreen if it's designed to show the selected file.
    //   // For simplicity, let's assume the presenter holds it and it's passed during save.
    //   addUserMessage("Image selected. Press Save to upload.");
    //   // Force a small state update to make PresentableWidgetBuilder rebuild if EditProfileInfoScreen uses it
    //   uiState.value = currentUiState.copyWith(userMessage: uiState.value.userMessage);
    // }
    addUserMessage("Image picking not implemented in this example.");
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
    appLog(
      "Saving profile: ${editNameController.text}, ${editEmailController.text}",
    );
    if (selectedProfileImageFile != null) {
      appLog("New profile image to upload: ${selectedProfileImageFile!.path}");
      // Handle image upload here
    }
    await Future.delayed(const Duration(seconds: 2));

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

  void _deleteAccount() {
    toggleLoading(loading: true);
    // Perform actual account deletion
    appLog("Deleting account...");
    Future.delayed(const Duration(seconds: 2), () {
      toggleLoading(loading: false);
      Get.offAll(
        () => const DriverAuthNavigatorScreen(),
      ); // Navigate to login or welcome screen
      addUserMessage(
        "Account deleted successfully (navigation not implemented).",
      );
    });
  }

  void goBack() {
    Get.back();
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
    super.dispose();
  }
}
