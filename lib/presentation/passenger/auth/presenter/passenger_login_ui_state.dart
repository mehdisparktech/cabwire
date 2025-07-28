import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';

class PassengerLoginUiState extends BaseUiState {
  final bool obscurePassword;
  final SigninResponseEntity? user;
  final bool isAuthenticated;

  const PassengerLoginUiState({
    required super.isLoading,
    required super.userMessage,
    this.obscurePassword = true,
    this.user,
    this.isAuthenticated = false,
  });

  factory PassengerLoginUiState.empty() {
    return const PassengerLoginUiState(
      isLoading: false,
      userMessage: null,
      obscurePassword: true,
      user: null,
      isAuthenticated: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    obscurePassword,
    user,
    isAuthenticated,
  ];

  PassengerLoginUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? obscurePassword,
    SigninResponseEntity? user,
    bool? isAuthenticated,
  }) {
    return PassengerLoginUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
