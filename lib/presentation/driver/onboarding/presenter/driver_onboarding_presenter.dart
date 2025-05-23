import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/onboarding/presenter/driver_onboarding_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverOnboardingPresenter extends BasePresenter<DriverOnboardingUiState> {
  final Obs<DriverOnboardingUiState> uiState = Obs(
    DriverOnboardingUiState.empty(),
  );

  DriverOnboardingUiState get currentUiState => uiState.value;
  PageController get pageController => currentUiState.pageController!;

  DriverOnboardingPresenter();

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
    }
  }

  void onGetStarted() {
    // Navigate to driver main page or login
    // Get.offAll(() => DriverMainPage());
    Get.back(); // Temporary: just go back to welcome screen
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
