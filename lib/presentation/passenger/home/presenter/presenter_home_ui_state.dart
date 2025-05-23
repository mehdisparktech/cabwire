import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerHomeUiState extends BaseUiState {
  const PassengerHomeUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory PassengerHomeUiState.empty() {
    return PassengerHomeUiState(isLoading: false, userMessage: '');
  }

  @override
  List<Object?> get props => [isLoading, userMessage];

  PassengerHomeUiState copyWith({bool? isLoading, String? userMessage}) {
    return PassengerHomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}
