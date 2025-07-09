import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/usecases/create_ride_request_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_categories_usecase.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/finding_rides_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'passenger_category_list_ui_state.dart';

class PassengerCategoryListPresenter
    extends BasePresenter<PassengerCategoryListUiState> {
  final GetPassengerCategoriesUseCase _getPassengerCategoriesUseCase;
  final CreateRideRequestUseCase _createRideRequestUseCase;

  final Obs<PassengerCategoryListUiState> uiState =
      Obs<PassengerCategoryListUiState>(PassengerCategoryListUiState.empty());
  PassengerCategoryListUiState get currentUiState => uiState.value;

  PassengerCategoryListPresenter(
    this._getPassengerCategoriesUseCase,
    this._createRideRequestUseCase,
  );

  void initializeWithArguments({
    required String serviceId,
    required LatLng pickupLocation,
    required String pickupAddress,
    required LatLng dropoffLocation,
    required String dropoffAddress,
  }) {
    uiState.value = currentUiState.copyWith(
      selectedService: serviceId,
      pickupLat: pickupLocation.latitude,
      pickupLng: pickupLocation.longitude,
      pickupAddress: pickupAddress,
      dropoffLat: dropoffLocation.latitude,
      dropoffLng: dropoffLocation.longitude,
      dropoffAddress: dropoffAddress,
      paymentMethod: 'offline', // Default payment method
    );
    loadPassengerCategories();
  }


  Future<void> loadPassengerCategories() async {
    try {
      await toggleLoading(loading: true);
      final result = await _getPassengerCategoriesUseCase();

      result.fold(
        (failure) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            error: failure.message,
          );
          addUserMessage(failure.message);
        },
        (categories) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            categories: categories,
            error: null,
          );
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      addUserMessage(e.toString());
    }
  }

  void selectCategory(PassengerCategoryEntity category) {
    if (currentUiState.selectedCategory?.id == category.id) {
      uiState.value = currentUiState.copyWith(selectedCategory: null);
    } else {
      uiState.value = currentUiState.copyWith(selectedCategory: category);
    }
  }

  void selectPaymentMethod(String method) {
    // Convert UI payment method names to API values
    final apiPaymentMethod = method == 'Online Payment' ? 'stripe' : 'offline';
    uiState.value = currentUiState.copyWith(paymentMethod: apiPaymentMethod);
  }

  /// Creates a ride request with the current parameters
  Future<void> createRideRequest(BuildContext context) async {
    try {
      // Validate required fields
      if (!_validateFields()) {
        return;
      }

      // Show loading indicator
      toggleLoading(loading: true);

      // Create parameters for use case
      final params = CreateRideRequestParams(
        service: currentUiState.selectedService!,
        category: currentUiState.selectedCategory!.id,
        pickupLocation: {
          'lat': currentUiState.pickupLat!,
          'lng': currentUiState.pickupLng!,
          'address': currentUiState.pickupAddress!,
        },
        dropoffLocation: {
          'lat': currentUiState.dropoffLat!,
          'lng': currentUiState.dropoffLng!,
          'address': currentUiState.dropoffAddress!,
        },
        duration: 30, // Default duration in minutes
        paymentMethod: currentUiState.paymentMethod!,
      );

      print(params);

      // Execute use case
      final result = await _createRideRequestUseCase.execute(params);

      // Handle result
      result.fold(
        (error) {
          uiState.value = currentUiState.copyWith(
            error: error,
            isLoading: false,
          );
          showMessage(message: error);
        },
        (_) {
          uiState.value = currentUiState.copyWith(
            isRideRequestSuccess: true,
            isLoading: false,
            error: null,
          );
          showMessage(message: 'Ride request created successfully');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => FindingRidesScreen()),
          );
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        error: e.toString(),
        isLoading: false,
        isRideRequestSuccess: false,
      );
      showMessage(message: e.toString());
    }
  }

  /// Validates if all required fields are filled
  bool _validateFields() {
    final currentState = currentUiState;

    if (currentState.selectedService == null) {
      showMessage(message: 'Please select a service');
      return false;
    }

    if (currentState.selectedCategory == null) {
      showMessage(message: 'Please select a category');
      return false;
    }

    if (currentState.pickupLat == null ||
        currentState.pickupLng == null ||
        currentState.pickupAddress == null) {
      showMessage(message: 'Please select a pickup location');
      return false;
    }

    if (currentState.dropoffLat == null ||
        currentState.dropoffLng == null ||
        currentState.dropoffAddress == null) {
      showMessage(message: 'Please select a dropoff location');
      return false;
    }

    if (currentState.paymentMethod == null) {
      showMessage(message: 'Please select a payment method');
      return false;
    }

    return true;
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
