import 'dart:async';
import 'dart:io';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/helpers/date_format_helper.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/domain/usecases/driver/driver_contact_usecase.dart';
import 'package:cabwire/domain/usecases/driver/delete_profile_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_profile_update_usecase.dart';
import 'package:cabwire/domain/usecases/driver/driver_vehicle_information_usecase.dart';
import 'package:cabwire/domain/usecases/driver_license_information_usecase.dart';
import 'package:cabwire/domain/usecases/privacy_and_policy_usecase.dart';
import 'package:cabwire/domain/usecases/terms_and_conditions_usecase.dart';
import 'package:cabwire/domain/usecases/update_profile_photo_usecase.dart';
import 'package:cabwire/presentation/common/components/camera/document_capture_screen.dart';
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
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/widgets.dart' as widgets;
// import 'package:image_picker/image_picker.dart'; // If you implement image picking

class DriverProfilePresenter extends BasePresenter<DriverProfileUiState> {
  final TermsAndConditionsUsecase _termsAndConditionsUsecase;
  final PrivacyAndPolicyUsecase _privacyAndPolicyUsecase;
  final DriverDeleteProfileUsecase _deleteProfileUsecase;
  final DriverProfileUpdateUsecase _updateProfileUsecase;
  final UpdateProfilePhotoUsecase _updateProfilePhotoUsecase;
  final DriverLicenseInformationUsecase _driverLicenseInfoUsecase;
  final DriverVehicleInformationUsecase _driverVehicleInformationUsecase;
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
    this._updateProfilePhotoUsecase,
    this._driverLicenseInfoUsecase,
    this._driverVehicleInformationUsecase,
  ) {
    // Make sure we have the latest data from SharedPreferences
    LocalStorage.getAllPrefData().then((_) {
      loadDriverProfile();
      _loadInitialData();
    });
    getTermsAndConditions();
    getPrivacyPolicy();
  }

  // Method to refresh profile data when screen is focused
  Future<void> refreshProfileData() async {
    await loadDriverProfile();
  }

  Future<void> loadDriverProfile() async {
    try {
      final DriverProfileModel? profile = await LocalStorage.getDriverProfile();
      if (profile != null) {
        // Log the email values for debugging
        appLog(
          "Profile email: ${profile.email}, LocalStorage email: ${LocalStorage.myEmail}",
          source: "DriverProfilePresenter",
        );

        uiState.value = currentUiState.copyWith(
          userProfile: UserProfileData(
            name: profile.name ?? '',
            // Use LocalStorage.myEmail if profile.email is empty or null
            email:
                (profile.email != null && profile.email!.isNotEmpty)
                    ? profile.email!
                    : LocalStorage.myEmail,
            phoneNumber: profile.contact ?? '01823450011',
            avatarUrl:
                profile.image != null
                    ? ApiEndPoint.imageUrl + profile.image!
                    : ApiEndPoint.imageUrl + LocalStorage.myImage,
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
    // Use LocalStorage.myEmail directly if profile.email is empty
    editEmailController.text =
        profile.email.isNotEmpty ? profile.email : LocalStorage.myEmail;
    editPhoneNumberController.text = profile.phoneNumber;
    editDobController.text = profile.dateOfBirth ?? '';
    editGenderController.text = profile.gender ?? '';

    // Debug log to verify email value
    appLog(
      "Populating email controller with: ${editEmailController.text}",
      source: "DriverProfilePresenter",
    );
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
    // First ensure we have the latest data
    appLog(
      "Navigate to edit profile with email: ${currentUiState.userProfile.email}, LocalStorage email: ${LocalStorage.myEmail}",
      source: "DriverProfilePresenter",
    );

    // Populate controllers
    _populateEditProfileControllers(currentUiState.userProfile);

    // Double check email is populated properly
    if (editEmailController.text.isEmpty) {
      editEmailController.text = LocalStorage.myEmail;
    }

    uiState.value = currentUiState.copyWith(
      userProfile: currentUiState.userProfile.copyWith(
        selectedProfileImageFile: null,
        selectedLicenseFrontImageFile: null,
        selectedLicenseBackImageFile: null,
        selectedVehicleBackImageFile: null,
        selectedVehicleFrontImageFile: null,
      ),
    );
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
      uiState.value = currentUiState.copyWith(
        userProfile: currentUiState.userProfile.copyWith(
          selectedProfileImageFile: File(image.path),
        ),
      );
      addUserMessage("Image selected. Press Save to upload.");
      uiState.value = currentUiState.copyWith(
        userMessage: uiState.value.userMessage,
      );
    }
  }

  Future<void> pickLicenseFrontImage(BuildContext context) async {
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
        if (source == ImageSource.camera) {
          final path = await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder:
                  (_) => const DocumentCaptureScreen(
                    title: 'Capture License Front',
                    instruction: 'Align the license front within the frame',
                  ),
            ),
          );
          if (path != null) {
            uiState.value = currentUiState.copyWith(
              userProfile: currentUiState.userProfile.copyWith(
                selectedLicenseFrontImageFile: File(path),
              ),
            );
            uiState.value = currentUiState.copyWith();
          }
        } else {
          final pickedFile = await ImagePicker().pickImage(
            source: source,
            imageQuality: 70,
          );
          if (pickedFile != null) {
            uiState.value = currentUiState.copyWith(
              userProfile: currentUiState.userProfile.copyWith(
                selectedLicenseFrontImageFile: File(pickedFile.path),
              ),
            );
            uiState.value = currentUiState.copyWith();
          }
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
        await showMessage(message: 'Failed to pick image: $e');
      }
    }
  }

  Future<void> pickLicenseBackImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uiState.value = currentUiState.copyWith(
        userProfile: currentUiState.userProfile.copyWith(
          selectedLicenseBackImageFile: File(image.path),
        ),
      );
      addUserMessage("Image selected. Press Save to upload.");
    }
  }

  Future<void> pickVehicleFrontImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uiState.value = currentUiState.copyWith(
        userProfile: currentUiState.userProfile.copyWith(
          selectedVehicleFrontImageFile: File(image.path),
        ),
      );
      addUserMessage("Image selected. Press Save to upload.");
    }
  }

  Future<void> pickVehicleBackImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uiState.value = currentUiState.copyWith(
        userProfile: currentUiState.userProfile.copyWith(
          selectedVehicleBackImageFile: File(image.path),
        ),
      );
      addUserMessage("Image selected. Press Save to upload.");
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
    if (currentUiState.userProfile.selectedProfileImageFile != null) {
      final imageResult = await _updateProfilePhotoUsecase.execute(
        LocalStorage.myEmail,
        currentUiState.userProfile.selectedProfileImageFile!.path,
      );

      imageResult.fold(
        (error) {
          addUserMessage(error, isError: true);
          return false;
        },
        (success) async {
          toggleLoading(loading: false);
          // Reload driver profile to get updated data from server
          await loadDriverProfile();

          // Refresh LocalStorage static variables
          await LocalStorage.getAllPrefData();
          return true;
        },
      );
    }

    // Update profile information
    final result = await _updateProfileUsecase.execute(
      editNameController.text,
      editPhoneNumberController.text,
      currentUiState.userProfile.selectedProfileImageFile?.path,
    );
    result.fold(
      (error) {
        toggleLoading(loading: false);
        addUserMessage(error, isError: true);
        return;
      },
      (success) async {
        // Add a small delay to ensure server has processed the image
        if (currentUiState.userProfile.selectedProfileImageFile != null) {
          await Future.delayed(const Duration(seconds: 1));
        }

        // Reload driver profile to get updated data from server
        await loadDriverProfile();

        // Refresh LocalStorage static variables
        await LocalStorage.getAllPrefData();

        // Update UI state with new profile data
        final updatedProfile = currentUiState.userProfile.copyWith(
          name: editNameController.text,
          email: editEmailController.text,
          phoneNumber: editPhoneNumberController.text,
          dateOfBirth: editDobController.text,
          gender: editGenderController.text,
          avatarUrl:
              ApiEndPoint.imageUrl + LocalStorage.myImage, // Updated image URL
        );

        uiState.value = currentUiState.copyWith(
          userProfile: updatedProfile,
          isLoading: false,
        );

        // Reset selected image file
        uiState.value = currentUiState.copyWith(
          userProfile: currentUiState.userProfile.copyWith(
            selectedProfileImageFile: null,
          ),
        );

        addUserMessage("Profile updated successfully!");
        showMessage(message: 'Profile updated successfully!');
        Get.back(); // Go back from edit screen
      },
    );
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

    final result = await _driverLicenseInfoUsecase.execute(
      licenseNumber: drivingLicenseNumberController.text.trim(),
      licenseExpiryDate: DateFormatHelper.formatDateForApi(
        DateTime.parse(drivingLicenseExpiryDateController.text),
      ),
      email: LocalStorage.myEmail,
      licenseImage:
          currentUiState.userProfile.selectedLicenseFrontImageFile?.path,
      licenseBackImage:
          currentUiState.userProfile.selectedLicenseBackImageFile?.path,
    );

    await result.fold(
      (errorMessage) async {
        await addUserMessage(errorMessage);
        await showMessage(message: errorMessage);
        toggleLoading(loading: false);
      },
      (successMessage) async {
        await addUserMessage(successMessage);
        await showMessage(message: 'License Information updated successfully!');
        await loadDriverProfile();
        await LocalStorage.getAllPrefData();
        Get.back();
        await Future.delayed(const Duration(seconds: 1));
        toggleLoading(loading: false);
      },
    );
  }

  Future<void> saveVehicleInfo() async {
    toggleLoading(loading: true);

    await executeTaskWithLoading(() async {
      // Parse the license expiry date to DateTime object

      if (currentUiState.userProfile.selectedVehicleFrontImageFile == null) {
        await showMessage(message: 'Please capture the vehicle front photo');
        toggleLoading(loading: false);
        return;
      }
      if (currentUiState.userProfile.selectedVehicleBackImageFile == null) {
        await showMessage(message: 'Please capture the vehicle back photo');
        toggleLoading(loading: false);
        return;
      }

      final result = await _driverVehicleInformationUsecase.execute(
        vehiclesMake: vehiclesMakeController.text.trim(),
        vehiclesModel: vehiclesModelController.text.trim(),
        vehiclesYear: "2028",
        vehiclesRegistrationNumber:
            vehiclesRegistrationNumberController.text.trim(),
        vehiclesInsuranceNumber: vehiclesInsuranceNumberController.text.trim(),
        vehiclesCategory: vehiclesCategoryController.text.trim(),
        email: LocalStorage.myEmail,
        vehicleFrontImage:
            currentUiState.userProfile.selectedVehicleFrontImageFile?.path,
        vehicleBackImage:
            currentUiState.userProfile.selectedVehicleBackImageFile?.path,
      );

      await result.fold(
        (errorMessage) async {
          await addUserMessage(errorMessage);
          await showMessage(message: errorMessage);
          toggleLoading(loading: false);
        },
        (successMessage) async {
          await addUserMessage(successMessage);
          await showMessage(
            message: 'Vehicle Information updated successfully!',
          );
          await loadDriverProfile();
          await LocalStorage.getAllPrefData();
          Get.back();
          await Future.delayed(const Duration(seconds: 1));
          toggleLoading(loading: false);
        },
      );
    });
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

  Future<void> _logoutUser() async {
    toggleLoading(loading: true);
    appLog("Logging out user...");

    // Clear all app preferences and cached profiles
    await LocalStorage.removeAllPrefData();
    await LocalStorage.removeDriverProfile();
    await LocalStorage.removePassengerProfile();

    // Clear image caches (memory + disk) so old avatars don't reappear
    try {
      await DefaultCacheManager().emptyCache();
    } catch (_) {}
    try {
      widgets.imageCache.clear();
      widgets.imageCache.clearLiveImages();
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));
    toggleLoading(loading: false);
    Get.offAll(() => DriverAuthNavigatorScreen());
    addUserMessage("Logged out successfully");
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
