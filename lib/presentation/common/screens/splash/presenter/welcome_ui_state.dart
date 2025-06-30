import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/enum/user_type.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/config/themes.dart';

class WelcomeUiState extends BaseUiState {
  const WelcomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.userType,
    required this.theme,
    required this.isFirstRun,
  });

  final UserType userType;
  final ThemeData theme;
  final bool isFirstRun;

  factory WelcomeUiState.empty() {
    return WelcomeUiState(
      isLoading: false,
      userMessage: '',
      userType: UserType.passenger,
      theme: AppTheme.passengerTheme,
      isFirstRun: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    userType,
    theme,
    isFirstRun,
  ];

  WelcomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    UserType? userType,
    ThemeData? theme,
    bool? isFirstRun,
  }) {
    return WelcomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      userType: userType ?? this.userType,
      theme: theme ?? this.theme,
      isFirstRun: isFirstRun ?? this.isFirstRun,
    );
  }
}
