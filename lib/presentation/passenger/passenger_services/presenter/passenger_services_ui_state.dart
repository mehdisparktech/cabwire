import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerServicesUiState extends BaseUiState {
  const PassengerServicesUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory PassengerServicesUiState.empty() {
    return const PassengerServicesUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  PassengerServicesUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return PassengerServicesUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
