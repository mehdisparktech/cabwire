import 'package:cabwire/core/base/base_ui_state.dart';
// You might want a dedicated UserProfileModel
// import 'package:cabwire/features/auth/models/user_profile_model.dart';

// Enum to manage which part of the profile flow is active
// This helps the Presenter and potentially a wrapper UI decide what to show/manage.
// However, since you have separate screen files, this might be less critical for UI rendering
// and more for presenter's internal logic or if you had one dynamic "form" screen.
// For now, let's assume navigation handles distinct screens.
// enum ProfileViewMode { main, editInfo, editPassword, editDriving, contactUs }

class PassengerProfileData {
  final String name;
  final String email; // Assuming email is part of profile info
  final String phoneNumber;
  final String avatarUrl; // Asset path or network URL
  final String? dateOfBirth;
  final String? gender;
  // Add other general profile fields

  const PassengerProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.dateOfBirth,
    this.gender,
  });

  // Factory for initial/empty state
  factory PassengerProfileData.empty() {
    return const PassengerProfileData(
      name: '',
      email: '',
      phoneNumber: '',
      avatarUrl: '', // Default or placeholder
      dateOfBirth: null,
      gender: null,
    );
  }

  PassengerProfileData copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? dateOfBirth,
    String? gender,
  }) {
    return PassengerProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}

class PassengerProfileUiState extends BaseUiState {
  final PassengerProfileData passengerProfile;

  // For forms - keeping it simple, presenter will manage controllers directly for now
  // Or you can store form field values here if you prefer not to pass controllers around.
  // final String editProfileName;
  // final String editProfileEmail;
  // ... and so on for all form fields. This can become very large.

  const PassengerProfileUiState({
    required super.isLoading,
    required super.userMessage,
    required this.passengerProfile,
  });

  factory PassengerProfileUiState.initial() {
    return PassengerProfileUiState(
      isLoading: false,
      userMessage: '',
      passengerProfile:
          PassengerProfileData.empty(), // Load actual data in presenter
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, passengerProfile];

  PassengerProfileUiState copyWith({
    bool? isLoading,
    String? userMessage,
    PassengerProfileData? passengerProfile,
  }) {
    return PassengerProfileUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      passengerProfile: passengerProfile ?? this.passengerProfile,
    );
  }
}
