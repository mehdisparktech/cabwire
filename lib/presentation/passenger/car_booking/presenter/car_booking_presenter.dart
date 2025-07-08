import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/create_ride_request_usecase.dart';
import 'car_booking_ui_state.dart';

class CarBookingPresenter extends BasePresenter<CarBookingUiState> {
  final Obs<CarBookingUiState> uiState = Obs<CarBookingUiState>(
    CarBookingUiState.empty(),
  );
  final CreateRideRequestUseCase _createRideRequestUseCase;

  CarBookingUiState get currentUiState => uiState.value;

  CarBookingPresenter(this._createRideRequestUseCase);

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  /// Updates the selected service
  void updateSelectedService(String serviceId) {
    uiState.value = currentUiState.copyWith(selectedService: serviceId);
  }

  /// Updates the selected category
  void updateSelectedCategory(String categoryId) {
    uiState.value = currentUiState.copyWith(selectedCategory: categoryId);
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
  Future<void> createRideRequest() async {
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
        category: currentUiState.selectedCategory!,
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
            errorMessage: error,
            isLoading: false,
            isRideRequestSuccess: false,
          );
          showMessage(message: error);
        },
        (_) {
          uiState.value = currentUiState.copyWith(
            isRideRequestSuccess: true,
            isLoading: false,
            errorMessage: null,
          );
          showMessage(message: 'Ride request created successfully');
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        errorMessage: e.toString(),
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
}
