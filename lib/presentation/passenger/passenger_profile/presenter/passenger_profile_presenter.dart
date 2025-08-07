import 'dart:async';
import 'dart:io';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart'; // For default assets
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart'; // Import LocalStorage
import 'package:cabwire/domain/usecases/passenger/delete_profile_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_profile_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/passenger_profile_photo_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/update_profile_usecase.dart';
import 'package:cabwire/domain/usecases/privacy_and_policy_usecase.dart';
import 'package:cabwire/domain/usecases/terms_and_conditions_usecase.dart';
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
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart'; // If you implement image picking

class PassengerProfilePresenter extends BasePresenter<PassengerProfileUiState> {
  final TermsAndConditionsUsecase _termsAndConditionsUsecase;
  final PrivacyAndPolicyUsecase _privacyAndPolicyUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final PassengerProfilePhotoUsecase _passengerProfilePhotoUsecase;
  final GetPassengerProfileUsecase _getPassengerProfileUsecase;
  final PassengerDeleteProfileUsecase _deleteProfileUsecase;
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
  // final TextEditingController editDobController =
  //     TextEditingController(); // Date of Birth
  // final TextEditingController editGenderController = TextEditingController();
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

  // Delete Account
  // final bool showPassword = false;
  // final bool showConfirmPassword = false;
  final TextEditingController deleteAccountPasswordController =
      TextEditingController();

  PassengerProfilePresenter(
    this._termsAndConditionsUsecase,
    this._privacyAndPolicyUsecase,
    this._updateProfileUsecase,
    this._passengerProfilePhotoUsecase,
    this._getPassengerProfileUsecase,
    this._deleteProfileUsecase,
  ) {
    _loadInitialData();
    getTermsAndConditions();
    getPrivacyPolicy();
    getPassengerProfile();
  }

  // Method to refresh profile data when screen is focused
  Future<void> refreshProfileData() async {
    await getPassengerProfile();
  }

  Future<void> _loadInitialData() async {
    toggleLoading(loading: true);
    // Simulate fetching user profile and driving info
    await Future.delayed(const Duration(seconds: 1));
    final ProfileModel? profile = await LocalStorage.getPassengerProfile();

    // Populate with fetched data
    final fetchedPassengerProfile = PassengerProfileData(
      name: profile?.name ?? 'Mehdi Hasan',
      email: profile?.email ?? '',
      phoneNumber: profile?.contact ?? '',
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
    // editDobController.text = profile.dateOfBirth ?? '';
    // editGenderController.text = profile.gender ?? '';
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
            },
            presenter: this,
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

    // Handle image upload first if there's a selected image
    if (selectedProfileImageFile != null) {
      final imageResult = await _passengerProfilePhotoUsecase.execute(
        LocalStorage.myEmail,
        selectedProfileImageFile!.path,
      );

      final imageUploadSuccess = imageResult.fold(
        (error) {
          addUserMessage(error, isError: true);
          return false;
        },
        (success) {
          return true;
        },
      );

      if (!imageUploadSuccess) {
        toggleLoading(loading: false);
        return;
      }
    }

    // Update profile information
    final result = await _updateProfileUsecase.execute(
      editNameController.text,
      editPhoneNumberController.text,
      selectedProfileImageFile?.path,
    );

    result.fold(
      (error) {
        showMessage(message: error);
        toggleLoading(loading: false);
        return;
      },
      (success) async {
        // Get current profile from storage
        final ProfileModel? currentProfile =
            await LocalStorage.getPassengerProfile();
        if (currentProfile != null) {
          // Create a new profile with updated values
          final updatedProfile = ProfileModel(
            id: currentProfile.id,
            name: editNameController.text,
            email: currentProfile.email,
            role: currentProfile.role,
            image: currentProfile.image,
            status: currentProfile.status,
            verified: currentProfile.verified,
            isOnline: currentProfile.isOnline,
            isDeleted: currentProfile.isDeleted,
            geoLocation: currentProfile.geoLocation,
            stripeAccountId: currentProfile.stripeAccountId,
            createdAt: currentProfile.createdAt,
            updatedAt: DateTime.now(),
            contact: editPhoneNumberController.text,
          );

          // Save updated profile back to local storage
          await LocalStorage.savePassengerProfile(updatedProfile);
        }

        // Add a small delay to ensure server has processed the image
        if (selectedProfileImageFile != null) {
          await Future.delayed(const Duration(seconds: 1));
        }

        // Refresh profile data to get latest image URL from server
        await getPassengerProfile();

        // Refresh LocalStorage static variables
        await LocalStorage.getAllPrefData();

        // Update UI state with new profile data
        final updatedPassengerProfile = PassengerProfileData(
          name: editNameController.text,
          email: currentProfile?.email ?? '',
          phoneNumber: editPhoneNumberController.text,
          avatarUrl: ApiEndPoint.imageUrl + LocalStorage.myImage,
          dateOfBirth: currentUiState.passengerProfile.dateOfBirth,
          gender: currentUiState.passengerProfile.gender,
        );

        uiState.value = currentUiState.copyWith(
          passengerProfile: updatedPassengerProfile,
        );

        // Reset selected image file
        selectedProfileImageFile = null;

        showMessage(message: success);
        toggleLoading(loading: false);
        Get.back();
      },
    );
  }

  Future<void> getPassengerProfile() async {
    final result = await _getPassengerProfileUsecase.execute();
    result.fold(
      (error) {
        addUserMessage(error);
        showMessage(message: error);
        toggleLoading(loading: false);
        return;
      },
      (success) {
        final profile = success.data;
        // Update LocalStorage with latest profile data
        if (profile != null) {
          LocalStorage.savePassengerProfile(profile);
        }

        uiState.value = currentUiState.copyWith(
          passengerProfile: PassengerProfileData(
            name: profile?.name ?? '',
            email: profile?.email ?? '',
            phoneNumber: profile?.contact ?? '',
            avatarUrl:
                profile?.image != null
                    ? ApiEndPoint.imageUrl + profile!.image!
                    : ApiEndPoint.imageUrl + LocalStorage.myImage,
            dateOfBirth: '',
            gender: 'Male',
          ),
        );
        toggleLoading(loading: false);
      },
    );
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
      // dateOfBirth: editDobController.text,
      // gender: editGenderController.text,
    );
    uiState.value = currentUiState.copyWith(
      passengerProfile: updatedPassengerInfo,
      isLoading: false,
    );
    showMessage(message: "Passenger information updated successfully!");
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
    showMessage(message: "Your message has been sent!");
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
        showMessage(message: "Logged out successfully");
      });
    } catch (e) {
      appLog("Error during logout: $e");
      toggleLoading(loading: false);
      addUserMessage("Error during logout. Please try again.", isError: true);
    }
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
          showMessage(message: success);
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
    final result = await _termsAndConditionsUsecase.execute(forType: 'user');
    result.fold(
      (error) {
        addUserMessage(
          "Failed to get terms and conditions: $error",
          isError: true,
        );
      },
      (termsAndConditions) {
        uiState.value = currentUiState.copyWith(
          termsAndConditions: termsAndConditions,
        );
      },
    );
  }

  Future<void> getPrivacyPolicy() async {
    final result = await _privacyAndPolicyUsecase.execute(forType: 'user');
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

  void toggleShowPassword() {
    uiState.value = currentUiState.copyWith(
      showPassword: !(currentUiState.showPassword ?? false),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    editNameController.dispose();
    editEmailController.dispose();
    editPhoneNumberController.dispose();
    // editDobController.dispose();
    // editGenderController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactPhoneNumberController.dispose();
    contactMessageController.dispose();
    deleteAccountPasswordController.dispose();
    super.dispose();
  }
}
