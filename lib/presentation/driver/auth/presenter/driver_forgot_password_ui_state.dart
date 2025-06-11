import 'package:cabwire/core/base/base_ui_state.dart';

class DriverForgotPasswordUiState extends BaseUiState {
  const DriverForgotPasswordUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory DriverForgotPasswordUiState.empty() =>
      const DriverForgotPasswordUiState(isLoading: false, userMessage: null);

  @override
  List<Object?> get props => [isLoading, userMessage];

  DriverForgotPasswordUiState copyWith({
    bool? isLoading,
    String? userMessage,
  }) => DriverForgotPasswordUiState(
    isLoading: isLoading ?? this.isLoading,
    userMessage: userMessage ?? this.userMessage,
  );
}
