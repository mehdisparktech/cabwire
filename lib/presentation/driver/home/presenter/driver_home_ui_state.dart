import 'package:cabwire/core/base/base_ui_state.dart';

class DriverHomeUiState extends BaseUiState {
  const DriverHomeUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory DriverHomeUiState.empty() {
    return DriverHomeUiState(isLoading: false, userMessage: '');
  }

  @override
  List<Object?> get props => [isLoading, userMessage];

  DriverHomeUiState copyWith({bool? isLoading, String? userMessage}) {
    return DriverHomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
