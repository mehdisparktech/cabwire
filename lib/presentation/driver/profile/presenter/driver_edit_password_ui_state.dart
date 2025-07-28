import 'package:cabwire/core/base/base_ui_state.dart';

class DriverEditPasswordUiState extends BaseUiState {
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;

  const DriverEditPasswordUiState({
    required super.isLoading,
    required super.userMessage,
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  });

  factory DriverEditPasswordUiState.empty() {
    return const DriverEditPasswordUiState(
      isLoading: true,
      userMessage: '',
      currentPassword: '',
      newPassword: '',
      confirmPassword: '',
    );
  }

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    isLoading,
    userMessage,
  ];

  DriverEditPasswordUiState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    String? userMessage,
  }) {
    return DriverEditPasswordUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
