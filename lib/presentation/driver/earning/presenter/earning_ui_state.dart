import 'package:cabwire/core/base/base_ui_state.dart';

class EarningUiState extends BaseUiState {
  const EarningUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory EarningUiState.empty() {
    return const EarningUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  EarningUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return EarningUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
