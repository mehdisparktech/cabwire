import 'package:cabwire/core/base/base_ui_state.dart';

class ChatUiState extends BaseUiState {
  const ChatUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory ChatUiState.empty() {
    return const ChatUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  ChatUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return ChatUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
