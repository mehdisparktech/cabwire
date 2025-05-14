import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:flutter/material.dart';

class PassengerOnboardingUiState extends BaseUiState {
  final int currentPage;
  final int totalPages;
  final PageController? pageController;

  const PassengerOnboardingUiState({
    required super.isLoading,
    required super.userMessage,
    required this.currentPage,
    required this.totalPages,
    this.pageController,
  });

  factory PassengerOnboardingUiState.empty() {
    return PassengerOnboardingUiState(
      isLoading: false,
      userMessage: '',
      currentPage: 0,
      totalPages: 3,
      pageController: PageController(),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    currentPage,
    totalPages,
    pageController,
  ];

  PassengerOnboardingUiState copyWith({
    bool? isLoading,
    String? userMessage,
    int? currentPage,
    int? totalPages,
    PageController? pageController,
  }) {
    return PassengerOnboardingUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageController: pageController ?? this.pageController,
    );
  }
}
