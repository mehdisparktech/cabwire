import 'package:cabwire/core/base/base_ui_state.dart';

class RideHistoryUiState extends BaseUiState {
  const RideHistoryUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory RideHistoryUiState.empty() {
    return const RideHistoryUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  RideHistoryUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return RideHistoryUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
