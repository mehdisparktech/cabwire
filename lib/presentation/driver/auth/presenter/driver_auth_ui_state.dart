import 'package:cabwire/core/base/base_ui_state.dart';

class DriverAuthUiState extends BaseUiState {
  const DriverAuthUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory DriverAuthUiState.empty() {
    return const DriverAuthUiState(userMessage: null, isLoading: true);
  }

  @override
  List<Object?> get props => [userMessage, isLoading];

  DriverAuthUiState copyWith({String? userMessage, bool? isLoading}) {
    return DriverAuthUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
