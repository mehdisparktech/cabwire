import 'package:cabwire/core/base/base_ui_state.dart';
// You might want a dedicated UserProfileModel
// import 'package:cabwire/features/auth/models/user_profile_model.dart';

// Enum to manage which part of the profile flow is active
// This helps the Presenter and potentially a wrapper UI decide what to show/manage.
// However, since you have separate screen files, this might be less critical for UI rendering
// and more for presenter's internal logic or if you had one dynamic "form" screen.
// For now, let's assume navigation handles distinct screens.
// enum ProfileViewMode { main, editInfo, editPassword, editDriving, contactUs }

class UserProfileData {
  final String name;
  final String email; // Assuming email is part of profile info
  final String phoneNumber;
  final String avatarUrl; // Asset path or network URL
  final String? dateOfBirth;
  final String? gender;
  // Add other general profile fields

  const UserProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.dateOfBirth,
    this.gender,
  });

  // Factory for initial/empty state
  factory UserProfileData.empty() {
    return const UserProfileData(
      name: '',
      email: '',
      phoneNumber: '',
      avatarUrl: '', // Default or placeholder
      dateOfBirth: null,
      gender: null,
    );
  }

  UserProfileData copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? dateOfBirth,
    String? gender,
  }) {
    return UserProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}

class DrivingInfoData {
  final String licenseNumber;
  final String licenseExpiryDate;
  final String licenseIssueDate;
  // Add other driving-specific fields

  const DrivingInfoData({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.licenseIssueDate,
  });

  factory DrivingInfoData.empty() {
    return const DrivingInfoData(
      licenseNumber: '',
      licenseExpiryDate: '',
      licenseIssueDate: '',
    );
  }

  DrivingInfoData copyWith({
    String? licenseNumber,
    String? licenseExpiryDate,
    String? licenseIssueDate,
  }) {
    return DrivingInfoData(
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      licenseIssueDate: licenseIssueDate ?? this.licenseIssueDate,
    );
  }
}

class DriverProfileUiState extends BaseUiState {
  final UserProfileData userProfile;
  final DrivingInfoData drivingInfo;

  // For forms - keeping it simple, presenter will manage controllers directly for now
  // Or you can store form field values here if you prefer not to pass controllers around.
  // final String editProfileName;
  // final String editProfileEmail;
  // ... and so on for all form fields. This can become very large.

  DriverProfileUiState({
    required super.isLoading,
    required super.userMessage,
    required this.userProfile,
    required this.drivingInfo,
  });

  factory DriverProfileUiState.initial() {
    return DriverProfileUiState(
      isLoading: false,
      userMessage: '',
      userProfile: UserProfileData.empty(), // Load actual data in presenter
      drivingInfo: DrivingInfoData.empty(), // Load actual data in presenter
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, userProfile, drivingInfo];

  DriverProfileUiState copyWith({
    bool? isLoading,
    String? userMessage,
    UserProfileData? userProfile,
    DrivingInfoData? drivingInfo,
  }) {
    return DriverProfileUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      userProfile: userProfile ?? this.userProfile,
      drivingInfo: drivingInfo ?? this.drivingInfo,
    );
  }
}
