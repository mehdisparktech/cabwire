import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/driver/auth/models/auth_user.dart';

class DriverLoginUiState extends BaseUiState {
  final bool obscurePassword;
  final AuthUser? user;
  final bool isAuthenticated;

  const DriverLoginUiState({
    required super.isLoading,
    required super.userMessage,
    this.obscurePassword = true,
    this.user,
    this.isAuthenticated = false,
  });

  factory DriverLoginUiState.empty() {
    return const DriverLoginUiState(
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

  DriverLoginUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? obscurePassword,
    AuthUser? user,
    bool? isAuthenticated,
  }) {
    return DriverLoginUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
