import 'dart:async';
import 'dart:io';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/app_assets.dart'; // For default assets
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart'; // Import LocalStorage
import 'package:cabwire/presentation/common/screens/splash/ui/welcome_screen.dart'; // Import WelcomeScreen
import 'package:cabwire/presentation/passenger/passenger_profile/ui/screens/passenger_contact_us_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/screens/passenger_edit_password_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/screens/passenger_edit_profile_info_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/screens/passenger_privacy_policy_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/screens/passenger_terms_and_conditions_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/widgets/passenger_delete_account_dialog.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/ui/widgets/passenger_logout_dialog.dart';
import 'package:cabwire/presentation/passenger/passenger_profile/presenter/passenger_profile_ui_state.dart';
// import 'package:cabwire/features/auth/ui/login_screen.dart'; // For navigation after logout/delete
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart'; // If you implement image picking

class PassengerProfilePresenter extends BasePresenter<PassengerProfileUiState> {
  final Obs<PassengerProfileUiState> uiState = Obs<PassengerProfileUiState>(
    PassengerProfileUiState.initial(),
  );
  PassengerProfileUiState get currentUiState => uiState.value;

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

  // Contact Us
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneNumberController =
      TextEditingController();
  final TextEditingController contactMessageController =
      TextEditingController();

  PassengerProfilePresenter() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    toggleLoading(loading: true);
    // Simulate fetching user profile and driving info
    await Future.delayed(const Duration(seconds: 1));
    final ProfileModel? profile = await LocalStorage.getPassengerProfile();

    // Populate with fetched data
    final fetchedPassengerProfile = PassengerProfileData(
      name: profile?.name ?? '',
      email: profile?.email ?? '',
      phoneNumber: '01625815151',
      avatarUrl: AppAssets.icProfileImage, // Placeholder or actual URL
      dateOfBirth: '1990-01-01',
      gender: 'Male',
    );

    uiState.value = currentUiState.copyWith(
      passengerProfile: fetchedPassengerProfile,
    );

    // Initialize controllers for edit forms with fetched data
    _populateEditProfileControllers(fetchedPassengerProfile);

    toggleLoading(loading: false);
  }

  void _populateEditProfileControllers(PassengerProfileData profile) {
    editNameController.text = profile.name;
    editEmailController.text = profile.email;
    editPhoneNumberController.text = profile.phoneNumber;
    editDobController.text = profile.dateOfBirth ?? '';
    editGenderController.text = profile.gender ?? '';
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
      currentUiState.passengerProfile,
    ); // Ensure controllers have latest data
    selectedProfileImageFile = null; // Reset selected image
    Get.to(() => PassengerEditProfileInfoScreen());
  }

  void navigateToEditPassword() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    Get.to(() => PassengerEditPasswordScreen());
  }

  void navigateToEditPassengerInfo() {
    // _populateEditPassengerControllers(
    //   currentUiState.passengerProfile,
    // ); // Ensure controllers have latest data
    // Get.to(() => EditPassengerInfoScreen());
  }

  void navigateToTermsAndConditions() {
    Get.to(() => PassengerTermsAndConditionsScreen());
  }

  void navigateToPrivacyPolicy() {
    Get.to(() => PassengerPrivacyPolicyScreen());
  }

  void navigateToContactUs() {
    contactNameController.text =
        currentUiState.passengerProfile.name; // Pre-fill
    contactEmailController.text =
        currentUiState.passengerProfile.email; // Pre-fill
    contactPhoneNumberController.clear();
    contactMessageController.clear();
    Get.to(() => PassengerContactUsScreen());
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
    final updatedProfile = currentUiState.passengerProfile.copyWith(
      name: editNameController.text,
      email: editEmailController.text,
      phoneNumber: editPhoneNumberController.text,
      dateOfBirth: editDobController.text,
      gender: editGenderController.text,
      // avatarUrl: newImageUrlFromServerIfUploaded, // Update if image was uploaded
    );
    uiState.value = currentUiState.copyWith(
      passengerProfile: updatedProfile,
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

  Future<void> savePassengerInfo() async {
    toggleLoading(loading: true);
    // Simulate API call
    appLog("Saving passenger info: ${editNameController.text}");
    await Future.delayed(const Duration(seconds: 2));
    final updatedPassengerInfo = currentUiState.passengerProfile.copyWith(
      name: editNameController.text,
      email: editEmailController.text,
      phoneNumber: editPhoneNumberController.text,
      dateOfBirth: editDobController.text,
      gender: editGenderController.text,
    );
    uiState.value = currentUiState.copyWith(
      passengerProfile: updatedPassengerInfo,
      isLoading: false,
    );
    addUserMessage("Passenger information updated successfully!");
    Get.back();
  }

  Future<void> submitContactUsForm() async {
    if (contactMessageController.text.isEmpty) {
      addUserMessage("Message cannot be empty.", isError: true);
      return;
    }
    toggleLoading(loading: true);
    // Simulate API call
    appLog(
      "Submitting contact form: ${contactNameController.text}, Message: ${contactMessageController.text}",
    );
    await Future.delayed(const Duration(seconds: 2));
    toggleLoading(loading: false);
    addUserMessage("Your message has been sent!");
    Get.back();
  }

  void _logoutUser() async {
    toggleLoading(loading: true);
    // Perform actual logout (clear tokens, user data)
    appLog("Logging out user...");

    try {
      // Clean all tokens and user data from LocalStorage
      // This will clear token, userId, isLogIn status, etc.
      // But will preserve firstTime flag which is stored in a different location
      await LocalStorage.removeAllPrefData();

      appLog("Successfully cleared user data and tokens");

      // Navigate to welcome screen after logout
      Future.delayed(const Duration(milliseconds: 500), () {
        toggleLoading(loading: false);
        // Navigate to welcome screen which will show auth screen since isLogIn is now false
        Get.offAll(() => WelcomeScreen());
        addUserMessage("Logged out successfully");
      });
    } catch (e) {
      appLog("Error during logout: $e");
      toggleLoading(loading: false);
      addUserMessage("Error during logout. Please try again.", isError: true);
    }
  }

  void _deleteAccount() async {
    toggleLoading(loading: true);
    // Perform actual account deletion
    appLog("Deleting account...");

    try {
      await LocalStorage.removeAllPrefData();

      appLog("Successfully deleted account and cleared user data");

      Future.delayed(const Duration(milliseconds: 500), () {
        toggleLoading(loading: false);
        Get.offAll(() => WelcomeScreen());
        addUserMessage("Account deleted successfully");
      });
    } catch (e) {
      appLog("Error during account deletion: $e");
      toggleLoading(loading: false);
      addUserMessage(
        "Error deleting account. Please try again.",
        isError: true,
      );
    }
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
    contactNameController.dispose();
    contactEmailController.dispose();
    contactPhoneNumberController.dispose();
    contactMessageController.dispose();
    super.dispose();
  }
}
