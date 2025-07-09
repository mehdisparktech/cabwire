import 'package:cabwire/core/base/base_ui_state.dart';

class DriverTripCloseOtpUiState extends BaseUiState {
  final bool isCompleted;

  const DriverTripCloseOtpUiState({
    required super.isLoading,
    required super.userMessage,
    this.isCompleted = false,
  });

  static DriverTripCloseOtpUiState initial() {
    return DriverTripCloseOtpUiState(
      isLoading: false,
      userMessage: null,
      isCompleted: false,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, isCompleted];

  DriverTripCloseOtpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isCompleted,
  }) {
    return DriverTripCloseOtpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
