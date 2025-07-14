import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerEditPasswordUiState extends BaseUiState {
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;

  const PassengerEditPasswordUiState({
    required super.isLoading,
    required super.userMessage,
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  });

  factory PassengerEditPasswordUiState.empty() {
    return const PassengerEditPasswordUiState(
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

  PassengerEditPasswordUiState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    String? userMessage,
  }) {
    return PassengerEditPasswordUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
