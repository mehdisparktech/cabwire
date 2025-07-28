import 'package:cabwire/core/base/base_ui_state.dart';

class DriverForgotPasswordUiState extends BaseUiState {
  final String? resetToken;
  const DriverForgotPasswordUiState({
    required super.isLoading,
    required super.userMessage,
    this.resetToken,
  });

  factory DriverForgotPasswordUiState.empty() =>
      const DriverForgotPasswordUiState(
        isLoading: false,
        userMessage: null,
        resetToken: '',
      );

  @override
  List<Object?> get props => [isLoading, userMessage, resetToken];

  DriverForgotPasswordUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? resetToken,
  }) => DriverForgotPasswordUiState(
    isLoading: isLoading ?? this.isLoading,
    userMessage: userMessage ?? this.userMessage,
    resetToken: resetToken ?? this.resetToken,
  );
}
