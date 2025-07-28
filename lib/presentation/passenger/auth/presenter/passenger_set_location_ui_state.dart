import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerSetLocationUiState extends BaseUiState {
  final String? location;

  const PassengerSetLocationUiState({
    required super.isLoading,
    required super.userMessage,
    this.location,
  });

  factory PassengerSetLocationUiState.empty() {
    return const PassengerSetLocationUiState(
      isLoading: false,
      userMessage: null,
      location: null,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, location];

  PassengerSetLocationUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? location,
  }) {
    return PassengerSetLocationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      location: location ?? this.location,
    );
  }
}
