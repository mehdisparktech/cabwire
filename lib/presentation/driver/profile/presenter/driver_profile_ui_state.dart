import 'package:cabwire/core/base/base_ui_state.dart';

class DriverProfileUiState extends BaseUiState {
  const DriverProfileUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory DriverProfileUiState.empty() {
    return const DriverProfileUiState(userMessage: null, isLoading: true);
  }

  @override
  List<Object?> get props => [userMessage, isLoading];

  DriverProfileUiState copyWith({String? userMessage, bool? isLoading}) {
    return DriverProfileUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
