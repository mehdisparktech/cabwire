import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerProfileUiState extends BaseUiState {
  const PassengerProfileUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory PassengerProfileUiState.empty() {
    return const PassengerProfileUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  PassengerProfileUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return PassengerProfileUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
