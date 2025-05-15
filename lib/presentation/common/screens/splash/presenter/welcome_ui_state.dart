import 'package:cabwire/core/base/base_ui_state.dart';

enum UserType { passenger, driver }

class WelcomeUiState extends BaseUiState {
  const WelcomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.userType,
  });

  final UserType userType;

  factory WelcomeUiState.empty() {
    return WelcomeUiState(
      isLoading: false,
      userMessage: '',
      userType: UserType.passenger,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, userType];

  WelcomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    UserType? userType,
  }) {
    return WelcomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      userType: userType ?? this.userType,
    );
  }
}
