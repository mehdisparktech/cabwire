import 'dart:async';

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_close_otp_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'ride_share_ui_state.dart';

class RideSharePresenter extends BasePresenter<RideShareUiState> {
  final ApiService _apiService = locate<ApiService>();
  Timer? _timer;

  final Obs<RideShareUiState> uiState;
  RideShareUiState get currentUiState => uiState.value;

  RideSharePresenter({String rideId = '', rideResponse})
    : uiState = Obs<RideShareUiState>(
        RideShareUiState.empty(rideId: rideId, rideResponse: rideResponse),
      ) {
    if (rideId.isNotEmpty && rideResponse != null) {
      _initialize();
    }
  }

  void init({required String rideId, required rideResponse}) {
    uiState.value = RideShareUiState.empty(
      rideId: rideId,
      rideResponse: rideResponse,
    );
    _initialize();
  }

  void _initialize() {
    _onRideStart();
    _onRideProcessing();
    _onRideEnd();
  }

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);
  }

  void _onRideStart() async {
    Duration duration = const Duration(seconds: 5);
    await Future.delayed(duration, () {
      uiState.value = currentUiState.copyWith(isRideStart: true);
    });
  }

  void _onRideProcessing() async {
    Duration duration = const Duration(seconds: 10);
    _timer = Timer(duration, () {
      uiState.value = currentUiState.copyWith(isRideProcessing: true);
    });
  }

  void _onRideEnd() async {
    Duration duration = const Duration(seconds: 15);
    _timer = Timer(duration, () {
      uiState.value = currentUiState.copyWith(
        isRideProcessing: false,
        isRideEnd: true,
      );
    });
  }

  Future<void> requestCloseRide() async {
    toggleLoading(loading: true);
    final result = await _apiService.post(
      ApiEndPoint.requestCloseRide + currentUiState.rideId,
    );
    toggleLoading(loading: false);

    result.fold(
      (error) {
        CustomToast(message: error.message);
      },
      (success) {
        CustomToast(message: success.message ?? '');
        Get.to(() => PassengerTripCloseOtpPage());
      },
    );
  }

  void handleTripClosureButtonPress() {
    if (currentUiState.isRideEnd) {
      requestCloseRide();
    } else {
      uiState.value = currentUiState.copyWith(isRideProcessing: true);
    }
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

  @override
  void onClose() {
    _timer?.cancel();
    _timer = null;
    currentUiState.mapController?.dispose();
    super.onClose();
  }
}
