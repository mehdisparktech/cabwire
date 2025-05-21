import 'package:cabwire/core/base/base_ui_state.dart';

class DriverLoginUiState extends BaseUiState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const DriverLoginUiState({
    required super.isLoading,
    required super.userMessage,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  factory DriverLoginUiState.empty() {
    return const DriverLoginUiState(
      isLoading: false,
      userMessage: null,
      obscurePassword: true,
      obscureConfirmPassword: true,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    obscurePassword,
    obscureConfirmPassword,
  ];

  DriverLoginUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return DriverLoginUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}
