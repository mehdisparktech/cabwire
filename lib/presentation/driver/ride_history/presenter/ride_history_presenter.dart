import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/app_assets.dart'; // For sample data if needed
import 'package:cabwire/domain/driver/entities/ride_history_item_entity.dart';
import 'package:cabwire/presentation/driver/home/widgets/successful_payment.dart'; // For navigation
import 'package:cabwire/presentation/driver/ride_history/presenter/ride_history_ui_state.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/ride_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For TextEditingController

class RideHistoryPresenter extends BasePresenter<RideHistoryUiState> {
  final Obs<RideHistoryUiState> uiState = Obs<RideHistoryUiState>(
    RideHistoryUiState.initial(),
  );
  RideHistoryUiState get currentUiState => uiState.value;

  final TextEditingController feedbackController = TextEditingController();

  RideHistoryPresenter() {
    fetchRideHistory();
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
    toggleLoading(loading: true);
    await Future.delayed(const Duration(seconds: 1));

    // Sample data - in a real app, this might just be summary data
    final sampleRides = [
      const RideHistoryItem(
        id: 'ride1',
        driverName: 'Santiago Dslab',
        driverLocation: 'Block B, Banasree | Oct 26, 2023',
        pickupLocation: 'Block B, Banasree, Dhaka.',
        dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
        distance: '10.5 km',
        duration: '45 Minutes',
        isCarRide: false,
        // Details might be null initially
      ),
      const RideHistoryItem(
        id: 'ride2',
        driverName: 'Another Driver',
        driverLocation: 'Mirpur | Oct 25, 2023',
        pickupLocation: 'Mirpur DOHS',
        dropoffLocation: 'Uttara Sector 10',
        distance: '15.2 km',
        duration: '1 Hour 5 Minutes',
        isCarRide: true,
        // Details might be null initially
      ),
    ];
    uiState.value = currentUiState.copyWith(
      rides: sampleRides,
      isLoading: false,
      viewMode: RideViewMode.list,
    );
  }

  Future<void> selectRideAndShowDetails(
    String rideId, {
    bool showFeedbackForm = false,
  }) async {
    RideHistoryItem? ride = currentUiState.rides.firstWhere(
      (r) => r.id == rideId,
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

    // Check if details for this ride are already "fetched" (i.e., vehicleNumber is not null)
    // This is a simple check; you might have a more robust way to know if details are loaded.
    bool detailsAlreadyLoaded = ride.vehicleNumber != null;

    if (detailsAlreadyLoaded && !showFeedbackForm) {
      // Details are already loaded, just switch view
      feedbackController.text = ride.existingFeedback ?? '';
      uiState.value = currentUiState.copyWith(
        selectedRideId: rideId,
        viewMode: RideViewMode.details,
        currentFeedbackText: feedbackController.text,
      );
      Get.to(() => RideDetailsScreen());
      return;
    }

    if (detailsAlreadyLoaded && showFeedbackForm) {
      feedbackController.clear();
      uiState.value = currentUiState.copyWith(
        selectedRideId: rideId,
        viewMode: RideViewMode.feedback,
        currentFeedbackText: '',
      );
      Get.to(() => RideDetailsScreen());
      return;
    }

    // If details are not loaded, or we need to show feedback form (which might clear existing feedback text)
    toggleLoading(loading: true);
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call for details

    // Simulate fetching details (in a real app, this would be an API call)
    final RideHistoryItem detailedRide = ride.copyWith(
      // Use copyWith to update the existing item
      vehicleNumber: 'DHK METRO HA 64-8549',
      vehicleModel: 'Volvo XC90',
      vehicleImageUrl: AppAssets.icCarImage,
      paymentMethod: 'Cash Payment Received',
      existingFeedback:
          showFeedbackForm
              ? null
              : (ride.id == 'ride1'
                  ? "Good service!"
                  : ride
                      .existingFeedback), // Keep existing if not showing feedback form
    );

    final updatedRides =
        currentUiState.rides.map((r) {
          return r.id == rideId ? detailedRide : r;
        }).toList();

    feedbackController.text =
        (showFeedbackForm ? '' : detailedRide.existingFeedback) ?? '';

    uiState.value = currentUiState.copyWith(
      rides: updatedRides,
      selectedRideId: rideId,
      viewMode: showFeedbackForm ? RideViewMode.feedback : RideViewMode.details,
      isLoading: false,
      currentFeedbackText: feedbackController.text,
    );
    Get.to(() => RideDetailsScreen());
  }

  void showFeedbackFormForSelectedRide() {
    if (currentUiState.selectedRideId != null) {
      RideHistoryItem? ride = currentUiState.selectedRideDetails;
      if (ride != null) {
        // If details are not fully loaded yet for feedback, we might need to fetch them.
        // For simplicity, assuming selectRideAndShowDetails(ride.id, showFeedbackForm: true) handles it.
        // Or, just update the view mode.
        feedbackController.clear();
        uiState.value = currentUiState.copyWith(
          viewMode: RideViewMode.feedback,
          currentFeedbackText: '',
        );
        // The UI (RideDetailsScreen) will re-render based on the new viewMode.
      }
    }
  }

  void submitFeedback() {
    if (currentUiState.selectedRideId == null) {
      addUserMessage("No ride selected to submit feedback.");
      return;
    }
    if (currentUiState.currentFeedbackText.isEmpty) {
      addUserMessage("Please enter your feedback.");
      return;
    }

    toggleLoading(loading: true);
    print(
      "Submitting feedback: ${currentUiState.currentFeedbackText} for ride ${currentUiState.selectedRideId}",
    );

    Future.delayed(const Duration(seconds: 1), () {
      final updatedRides =
          currentUiState.rides.map((r) {
            if (r.id == currentUiState.selectedRideId) {
              return r.copyWith(
                existingFeedback: currentUiState.currentFeedbackText,
              );
            }
            return r;
          }).toList();

      uiState.value = currentUiState.copyWith(
        isLoading: false,
        rides: updatedRides,
        viewMode: RideViewMode.details,
      );
      addUserMessage("Feedback submitted successfully!");
      Get.off(() => SuccessfulPayment());
    });
  }

  void goBackFromDetails() {
    // Important: When going back from details, reset selectedRideId and viewMode
    feedbackController.clear();
    uiState.value = currentUiState.copyWith(
      clearSelectedRideId: true, // Explicitly set selectedRideId to null
      viewMode: RideViewMode.list,
      currentFeedbackText: '',
    );
    Get.back(); // This pops RideDetailsScreen
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
