import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/auth/ui/auth_navigator.dart';
import 'package:cabwire/presentation/passenger/onboarding/presenter/passenger_onboarding_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerOnboardingPresenter
    extends BasePresenter<PassengerOnboardingUiState> {
  final Obs<PassengerOnboardingUiState> uiState = Obs(
    PassengerOnboardingUiState.empty(),
  );

  PassengerOnboardingUiState get currentUiState => uiState.value;
  PageController get pageController => currentUiState.pageController!;

  PassengerOnboardingPresenter();

  @override
  void onClose() {
    currentUiState.pageController?.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    uiState.value = currentUiState.copyWith(currentPage: page);
  }

  void onNextPage() {
    if (currentUiState.currentPage < currentUiState.totalPages - 1) {
      pageController.animateToPage(
        currentUiState.currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      if (currentUiState.currentPage == currentUiState.totalPages - 1) {
        uiState.value = currentUiState.copyWith(showSkipButton: false);
      }
    }
  }

  void onSkip() {
    if (currentUiState.currentPage < currentUiState.totalPages - 1) {
      pageController.animateToPage(
        currentUiState.totalPages,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
      uiState.value = currentUiState.copyWith(showSkipButton: false);
    }
  }

  void onBack() {
    if (currentUiState.currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
      uiState.value = currentUiState.copyWith(showSkipButton: true);
    }
  }

  void onGetStarted() {
    // Navigate to AuthNavigator for login/signup
    Get.to(() => const AuthNavigator());
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
