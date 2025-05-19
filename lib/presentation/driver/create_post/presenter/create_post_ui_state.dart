import 'package:cabwire/core/base/base_ui_state.dart';

class CreatePostUiState extends BaseUiState {
  const CreatePostUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory CreatePostUiState.empty() {
    return const CreatePostUiState(
      userMessage: null,
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        userMessage,
        isLoading,
      ];

  CreatePostUiState copyWith({
    String? userMessage,
    bool? isLoading,
  }) {
    return CreatePostUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
