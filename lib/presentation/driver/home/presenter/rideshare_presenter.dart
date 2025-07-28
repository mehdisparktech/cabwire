import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/chat_page.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/driver_trip_close_otp_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidesharePresenter extends BasePresenter<RideshareUiState> {
  final ApiService apiService;
  final Obs<RideshareUiState> uiState = Obs<RideshareUiState>(
    RideshareUiState.initial(),
  );
  RideshareUiState get currentUiState => uiState.value;
  Timer? _rideStartTimer;

  RidesharePresenter(this.apiService) {
    _initialize();
  }

  void _initialize() {
    _startRideTimer();
  }

  void setRideRequest(RideRequestModel rideRequest) {
    uiState.value = currentUiState.copyWith(
      rideRequest: rideRequest,
      mapCenter: rideRequest.pickupLocation,
    );
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
          target: currentUiState.rideRequest!.pickupLocation,
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> startRide() async {
    //uiState.value = currentUiState.copyWith(isRideProcessing: true);
    final response = await apiService.patch(
      ApiEndPoint.startRide + currentUiState.rideRequest!.rideId,
    );
    response.fold(
      (failure) {
        uiState.value = currentUiState.copyWith(
          isRideProcessing: false,
          userMessage: failure.message,
        );
        CustomToast(message: failure.message);
      },
      (success) {
        uiState.value = currentUiState.copyWith(
          isRideProcessing: true,
          userMessage: success.message,
          isRideStart: true,
        );
        CustomToast(message: success.message!);
      },
    );
  }

  void endRide() {
    uiState.value = currentUiState.copyWith(
      isRideEnd: true,
      isRideProcessing: false,
      isRideStart: false,
    );

    Get.off(
      () => DriverTripCloseOtpPage(rideId: currentUiState.rideRequest!.rideId),
    );
  }

  void navigateToChat() {
    Get.to(() => ChatPage(chatId: '123'));
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
