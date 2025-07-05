import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerEmailVerifyUiState extends BaseUiState {
  final String email;
  final bool isSignUp;
  const PassengerEmailVerifyUiState({
    required super.isLoading,
    required this.email,
    required this.isSignUp,
    required super.userMessage,
  });

  factory PassengerEmailVerifyUiState.empty() {
    return const PassengerEmailVerifyUiState(
      isLoading: false,
      userMessage: null,
      email: "",
      isSignUp: false,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage];

  PassengerEmailVerifyUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? email,
    bool? isSignUp,
  }) {
    return PassengerEmailVerifyUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      email: email ?? this.email,
      isSignUp: isSignUp ?? this.isSignUp,
    );
  }
}
