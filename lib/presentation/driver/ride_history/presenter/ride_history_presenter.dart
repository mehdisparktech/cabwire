import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/app_assets.dart'; // For sample data if needed
import 'package:cabwire/data/mappers/ride_history_mapper.dart';
import 'package:cabwire/domain/entities/driver/ride_history_item_entity.dart';
import 'package:cabwire/domain/usecases/get_ride_history_usecase.dart';
import 'package:cabwire/presentation/driver/home/ui/widgets/successful_payment.dart'; // For navigation
import 'package:cabwire/presentation/driver/ride_history/presenter/ride_history_ui_state.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/screens/ride_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For TextEditingController

class RideHistoryPresenter extends BasePresenter<RideHistoryUiState> {
  final GetRideHistoryUseCase _getRideHistoryUseCase;
  final Obs<RideHistoryUiState> uiState = Obs<RideHistoryUiState>(
    RideHistoryUiState.initial(),
  );
  RideHistoryUiState get currentUiState => uiState.value;

  final TextEditingController feedbackController = TextEditingController();

  RideHistoryPresenter(this._getRideHistoryUseCase) {
    _initialize();
  }

  void _initialize() {
    fetchRideHistory();
    _setupFeedbackListener();
  }

  void _setupFeedbackListener() {
    feedbackController.addListener(() {
      if (currentUiState.viewMode == RideViewMode.feedback) {
        uiState.value = currentUiState.copyWith(
          currentFeedbackText: feedbackController.text,
        );
      }
    });
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  Future<void> fetchRideHistory() async {
    await toggleLoading(loading: true);

    try {
      final result = await _getRideHistoryUseCase.execute();
      result.fold((failure) => throw Exception(failure), (data) {
        final mappedRides = RideHistoryMapper().mapToRideHistoryItemList(data);
        uiState.value = currentUiState.copyWith(
          rides: mappedRides,
          viewMode: RideViewMode.list,
        );
      });
    } finally {
      await toggleLoading(loading: false);
    }
  }

  Future<void> selectRideAndShowDetails(
    String rideId, {
    bool showFeedbackForm = false,
  }) async {
    final RideHistoryItem ride = _findRideById(rideId);
    final bool detailsAlreadyLoaded = ride.vehicleNumber != null;

    if (detailsAlreadyLoaded) {
      _handleExistingRideDetails(rideId, showFeedbackForm);
      return;
    }

    await _loadRideDetails(rideId, showFeedbackForm);
  }

  RideHistoryItem _findRideById(String rideId) {
    return currentUiState.rides.firstWhere(
      (ride) => ride.id == rideId,
      orElse:
          () => RideHistoryItem(
            id: '',
            driverName: '',
            driverLocation: '',
            pickupLocation: '',
            dropoffLocation: '',
            distance: '',
            duration: '',
            isCarRide: false,
          ),
    );
  }

  void _handleExistingRideDetails(String rideId, bool showFeedbackForm) {
    if (showFeedbackForm) {
      feedbackController.clear();
      uiState.value = currentUiState.copyWith(
        selectedRideId: rideId,
        viewMode: RideViewMode.feedback,
        currentFeedbackText: '',
      );
    } else {
      final ride = _findRideById(rideId);
      feedbackController.text = ride.existingFeedback ?? '';
      uiState.value = currentUiState.copyWith(
        selectedRideId: rideId,
        viewMode: RideViewMode.details,
        currentFeedbackText: feedbackController.text,
      );
    }

    Get.to(() => RideDetailsScreen());
  }

  Future<void> _loadRideDetails(String rideId, bool showFeedbackForm) async {
    await toggleLoading(loading: true);

    try {
      // Simulate API call for details
      await Future.delayed(const Duration(milliseconds: 500));

      final ride = _findRideById(rideId);
      final RideHistoryItem detailedRide = ride.copyWith(
        vehicleNumber: 'DHK METRO HA 64-8549',
        vehicleModel: 'Volvo XC90',
        vehicleImageUrl: AppAssets.icCarImage,
        paymentMethod: 'Cash Payment Received',
        existingFeedback:
            showFeedbackForm
                ? null
                : (rideId == 'ride1' ? "Good service!" : ride.existingFeedback),
      );

      final updatedRides =
          currentUiState.rides
              .map((r) => r.id == rideId ? detailedRide : r)
              .toList();

      feedbackController.text =
          (showFeedbackForm ? '' : detailedRide.existingFeedback) ?? '';

      uiState.value = currentUiState.copyWith(
        rides: updatedRides,
        selectedRideId: rideId,
        viewMode:
            showFeedbackForm ? RideViewMode.feedback : RideViewMode.details,
        currentFeedbackText: feedbackController.text,
      );

      Get.to(() => RideDetailsScreen());
    } finally {
      await toggleLoading(loading: false);
    }
  }

  void showFeedbackFormForSelectedRide() {
    if (currentUiState.selectedRideId != null) {
      final ride = currentUiState.selectedRideDetails;
      if (ride != null) {
        feedbackController.clear();
        uiState.value = currentUiState.copyWith(
          viewMode: RideViewMode.feedback,
          currentFeedbackText: '',
        );
      }
    }
  }

  Future<void> submitFeedback() async {
    if (currentUiState.selectedRideId == null) {
      await addUserMessage("No ride selected to submit feedback.");
      return;
    }

    if (currentUiState.currentFeedbackText.isEmpty) {
      await addUserMessage("Please enter your feedback.");
      return;
    }

    await toggleLoading(loading: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedRides =
          currentUiState.rides
              .map(
                (r) =>
                    r.id == currentUiState.selectedRideId
                        ? r.copyWith(
                          existingFeedback: currentUiState.currentFeedbackText,
                        )
                        : r,
              )
              .toList();

      uiState.value = currentUiState.copyWith(
        rides: updatedRides,
        viewMode: RideViewMode.details,
      );

      await addUserMessage("Feedback submitted successfully!");
      Get.off(() => SuccessfulPayment());
    } finally {
      await toggleLoading(loading: false);
    }
  }

  void goBackFromDetails() {
    feedbackController.clear();
    uiState.value = currentUiState.copyWith(
      clearSelectedRideId: true,
      viewMode: RideViewMode.list,
      currentFeedbackText: '',
    );
    // Use microtask to ensure state changes are completed before navigation
    Future.microtask(() => Get.back());
  }

  void goBackFromHistoryList() {
    Get.back();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }
}
