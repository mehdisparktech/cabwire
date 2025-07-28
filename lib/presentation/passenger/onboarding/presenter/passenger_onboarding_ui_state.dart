import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:flutter/material.dart';

class PassengerOnboardingUiState extends BaseUiState {
  final int currentPage;
  final int totalPages;
  final PageController? pageController;
  final bool? showSkipButton;

  const PassengerOnboardingUiState({
    required super.isLoading,
    required super.userMessage,
    required this.currentPage,
    required this.totalPages,
    this.pageController,
    this.showSkipButton,
  });

  factory PassengerOnboardingUiState.empty() {
    return PassengerOnboardingUiState(
      isLoading: false,
      userMessage: '',
      currentPage: 0,
      totalPages: 3,
      pageController: PageController(),
      showSkipButton: true,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    currentPage,
    totalPages,
    pageController,
    showSkipButton,
  ];

  PassengerOnboardingUiState copyWith({
    bool? isLoading,
    String? userMessage,
    int? currentPage,
    int? totalPages,
    PageController? pageController,
    bool? showSkipButton,
  }) {
    return PassengerOnboardingUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageController: pageController ?? this.pageController,
      showSkipButton: showSkipButton ?? this.showSkipButton,
    );
  }
}
