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
          'image': AppAssets.stripePayments,
          'title': 'Choose Your First Ride',
          'subtitle':
              'Your first customer awaits. Select and begin your journey with us!',
        },
        {
          'image': AppAssets.icVintageCar,
          'title': 'Receive Ride Requests',
          'subtitle':
              'Get notified of nearby riders and choose which rides to accept.',
        },
        {
          'image': AppAssets.icThankYou,
          'title': 'Thank You!',
          'subtitle':
              'You’re all set. Start earning with Cabwire and enjoy the ride!',
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
