import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:flutter/material.dart';

class DriverOnboardingUiState extends BaseUiState {
  final int currentPage;
  final int totalPages;
  final PageController? pageController;
  final List<Map<String, dynamic>> onboardingPages;

  const DriverOnboardingUiState({
    required super.isLoading,
    required super.userMessage,
    required this.currentPage,
    required this.totalPages,
    this.pageController,
    required this.onboardingPages,
  });

  factory DriverOnboardingUiState.empty() {
    return DriverOnboardingUiState(
      isLoading: false,
      userMessage: '',
      currentPage: 0,
      totalPages: 3,
      pageController: PageController(),
      onboardingPages: [
        {
          'image': AppAssets.icSplash1,
          'title': 'Welcome Driver',
          'subtitle': 'Start earning with our easy-to-use driver platform.',
        },
        {
          'image': AppAssets.icSplash2,
          'title': 'Receive Ride Requests',
          'subtitle':
              'Get notified of nearby riders and choose which rides to accept.',
        },
        {
          'image': AppAssets.icSplash3,
          'title': 'Track Earnings',
          'subtitle':
              'Monitor your daily, weekly, and monthly income with detailed breakdowns.',
          'showBackButton': true,
        },
      ],
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    currentPage,
    totalPages,
    pageController,
    onboardingPages,
  ];

  DriverOnboardingUiState copyWith({
    bool? isLoading,
    String? userMessage,
    int? currentPage,
    int? totalPages,
    PageController? pageController,
    List<Map<String, dynamic>>? onboardingPages,
  }) {
    return DriverOnboardingUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageController: pageController ?? this.pageController,
      onboardingPages: onboardingPages ?? this.onboardingPages,
    );
  }
}
