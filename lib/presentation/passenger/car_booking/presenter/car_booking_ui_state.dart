import 'package:cabwire/core/base/base_ui_state.dart';

class CarBookingUiState extends BaseUiState {
  const CarBookingUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory CarBookingUiState.empty() {
    return const CarBookingUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  CarBookingUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return CarBookingUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
