import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/config/themes.dart';

enum UserType { passenger, driver }

class WelcomeUiState extends BaseUiState {
  const WelcomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.userType,
    required this.theme,
  });

  final UserType userType;
  final ThemeData theme;

  factory WelcomeUiState.empty() {
    return WelcomeUiState(
      isLoading: false,
      userMessage: '',
      userType: UserType.passenger,
      theme: AppTheme.passengerTheme,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, userType, theme];

  WelcomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    UserType? userType,
    ThemeData? theme,
  }) {
    return WelcomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      userType: userType ?? this.userType,
      theme: theme ?? this.theme,
    );
  }
}
