import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/usecases/create_ride_request_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_categories_usecase.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/finding_rides_screen.dart';
import 'package:flutter/material.dart';
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

  @override
  void onInit() {
    super.onInit();
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

  /// Updates the selected service
  void updateSelectedService(String serviceId) {
    uiState.value = currentUiState.copyWith(selectedService: serviceId);
  }

  /// Updates the selected category
  void updateSelectedCategory(String categoryId) {
    uiState.value = currentUiState.copyWith(
      selectedCategory: currentUiState.categories.firstWhere(
        (category) => category.id == categoryId,
      ),
    );
  }

  /// Updates the pickup location
  void updatePickupLocation({
    required double lat,
    required double lng,
    required String address,
  }) {
    uiState.value = currentUiState.copyWith(
      pickupLat: lat,
      pickupLng: lng,
      pickupAddress: address,
    );
  }

  /// Updates the dropoff location
  void updateDropoffLocation({
    required double lat,
    required double lng,
    required String address,
  }) {
    uiState.value = currentUiState.copyWith(
      dropoffLat: lat,
      dropoffLng: lng,
      dropoffAddress: address,
    );
  }

  /// Updates the payment method
  void updatePaymentMethod(String method) {
    uiState.value = currentUiState.copyWith(paymentMethod: method);
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
        pickupLat: currentUiState.pickupLat!,
        pickupLng: currentUiState.pickupLng!,
        pickupAddress: currentUiState.pickupAddress!,
        dropoffLat: currentUiState.dropoffLat!,
        dropoffLng: currentUiState.dropoffLng!,
        dropoffAddress: currentUiState.dropoffAddress!,
        paymentMethod: currentUiState.paymentMethod!,
      );

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
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => FindingRidesScreen()));
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

  void navigateToFindingRidesScreen(BuildContext context) {
    createRideRequest(context);
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
