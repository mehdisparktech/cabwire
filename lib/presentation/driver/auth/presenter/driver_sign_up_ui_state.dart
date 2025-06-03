import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart';

/// Shared state for the entire driver registration process
class DriverSignUpUiState extends BaseUiState {
  //final DriverRegistrationEntity? registration;
  final DriverEntity? driver;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final int currentStep;
  final bool isRegistered;

  const DriverSignUpUiState({
    required super.isLoading,
    required super.userMessage,
    required this.driver,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.currentStep = 0,
    this.isRegistered = false,
  });

  factory DriverSignUpUiState.empty() {
    return DriverSignUpUiState(
      isLoading: false,
      userMessage: null,
      driver: null,
      obscurePassword: true,
      obscureConfirmPassword: true,
      currentStep: 0,
      isRegistered: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    driver,
    obscurePassword,
    obscureConfirmPassword,
    currentStep,
    isRegistered,
  ];

  DriverSignUpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    DriverEntity? driver,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    int? currentStep,
    bool? isRegistered,
  }) {
    return DriverSignUpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      driver: driver ?? this.driver,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      currentStep: currentStep ?? this.currentStep,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
