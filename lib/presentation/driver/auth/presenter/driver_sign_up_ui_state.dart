import 'package:cabwire/core/base/base_ui_state.dart';

class SignUpUiState extends BaseUiState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const SignUpUiState({
    required super.userMessage,
    required super.isLoading,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
  });

  factory SignUpUiState.empty() {
    return const SignUpUiState(
      userMessage: null,
      isLoading: false,
      obscurePassword: true,
      obscureConfirmPassword: true,
    );
  }

  @override
  List<Object?> get props => [
    userMessage,
    isLoading,
    obscurePassword,
    obscureConfirmPassword,
  ];

  SignUpUiState copyWith({
    String? userMessage,
    bool? isLoading,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return SignUpUiState(
      userMessage: userMessage ?? this.userMessage,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}
