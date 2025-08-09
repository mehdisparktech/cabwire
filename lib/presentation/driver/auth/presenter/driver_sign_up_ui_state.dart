import 'dart:io';

import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';

/// Shared state for the entire driver registration process
class DriverSignUpUiState extends BaseUiState {
  //final DriverRegistrationEntity? registration;
  final SignupResponseEntity? user;
  final DriverEntity? driver;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final int currentStep;
  final bool isRegistered;
  final DriverProfileModel? profile;
  final String? resetToken;
  final File? selectedProfileImageFile;
  final bool selectedLicenseFrontImageFile;
  final bool selectedLicenseBackImageFile;
  final bool selectedVehicleFrontImageFile;
  final bool selectedVehicleBackImageFile;
  const DriverSignUpUiState({
    required super.isLoading,
    required super.userMessage,
    required this.user,
    required this.driver,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.currentStep = 0,
    this.isRegistered = false,
    this.profile,
    this.resetToken,
    this.selectedProfileImageFile,
    this.selectedLicenseFrontImageFile = false,
    this.selectedLicenseBackImageFile = false,
    this.selectedVehicleFrontImageFile = false,
    this.selectedVehicleBackImageFile = false,
  });

  factory DriverSignUpUiState.empty() {
    return DriverSignUpUiState(
      isLoading: false,
      userMessage: null,
      user: null,
      driver: null,
      obscurePassword: true,
      obscureConfirmPassword: true,
      currentStep: 0,
      isRegistered: false,
      profile: null,
      resetToken: null,
      selectedProfileImageFile: null,
      selectedLicenseFrontImageFile: false,
      selectedLicenseBackImageFile: false,
      selectedVehicleFrontImageFile: false,
      selectedVehicleBackImageFile: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    user,
    driver,
    obscurePassword,
    obscureConfirmPassword,
    currentStep,
    isRegistered,
    profile,
    resetToken,
    selectedProfileImageFile,
    selectedLicenseFrontImageFile,
    selectedLicenseBackImageFile,
    selectedVehicleFrontImageFile,
    selectedVehicleBackImageFile,
  ];

  DriverSignUpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    SignupResponseEntity? user,
    DriverEntity? driver,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    int? currentStep,
    bool? isRegistered,
    DriverProfileModel? profile,
    String? resetToken,
    File? selectedProfileImageFile,
    bool? selectedLicenseFrontImageFile,
    bool? selectedLicenseBackImageFile,
    bool? selectedVehicleFrontImageFile,
    bool? selectedVehicleBackImageFile,
  }) {
    return DriverSignUpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      user: user ?? this.user,
      driver: driver ?? this.driver,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      currentStep: currentStep ?? this.currentStep,
      isRegistered: isRegistered ?? this.isRegistered,
      profile: profile ?? this.profile,
      resetToken: resetToken ?? this.resetToken,
      selectedProfileImageFile:
          selectedProfileImageFile ?? this.selectedProfileImageFile,
      selectedLicenseFrontImageFile:
          selectedLicenseFrontImageFile ?? this.selectedLicenseFrontImageFile,
      selectedLicenseBackImageFile:
          selectedLicenseBackImageFile ?? this.selectedLicenseBackImageFile,
      selectedVehicleFrontImageFile:
          selectedVehicleFrontImageFile ?? this.selectedVehicleFrontImageFile,
      selectedVehicleBackImageFile:
          selectedVehicleBackImageFile ?? this.selectedVehicleBackImageFile,
    );
  }
}
