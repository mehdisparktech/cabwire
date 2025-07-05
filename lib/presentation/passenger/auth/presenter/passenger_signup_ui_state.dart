import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerSignupUiState extends BaseUiState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isSuccess;

  const PassengerSignupUiState({
    required super.isLoading,
    required super.userMessage,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isSuccess,
  });

  factory PassengerSignupUiState.empty() {
    return const PassengerSignupUiState(
      isLoading: false,
      userMessage: null,
      obscurePassword: true,
      obscureConfirmPassword: true,
      isSuccess: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isSuccess,
    obscurePassword,
    obscureConfirmPassword,
  ];

  PassengerSignupUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isSuccess,
  }) {
    return PassengerSignupUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
