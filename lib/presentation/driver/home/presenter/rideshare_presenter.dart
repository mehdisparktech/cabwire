import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/chat_page.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/driver_trip_close_otp_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidesharePresenter extends BasePresenter<RideshareUiState> {
  final Obs<RideshareUiState> uiState;
  Timer? _rideStartTimer;

  RidesharePresenter(RideRequestModel rideRequest)
    : uiState = Obs<RideshareUiState>(RideshareUiState.initial(rideRequest)) {
    _initialize();
  }

  RideshareUiState get currentUiState => uiState.value;

  void _initialize() {
    _startRideTimer();
  }

  void _startRideTimer() {
    _rideStartTimer = Timer(const Duration(seconds: 5), () {
      uiState.value = currentUiState.copyWith(isRideStart: true);
    });
  }

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);

    // Move camera to the pickup location
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentUiState.rideRequest.pickupLocation,
          zoom: 14.0,
        ),
      ),
    );
  }

  void startRide() {
    uiState.value = currentUiState.copyWith(isRideProcessing: true);
  }

  void endRide() {
    Get.off(() => DriverTripCloseOtpPage());
  }

  void navigateToChat() {
    Get.to(() => ChatPage());
  }

  void navigateToCall() {
    Get.to(() => const AudioCallScreen());
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  @override
  void onClose() {
    _rideStartTimer?.cancel();
    super.onClose();
  }
}
