import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_trip_start_otp_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/rideshare_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverTripStartOtpPresenter
    extends BasePresenter<DriverTripStartOtpUiState> {
  final SocketService _socketService;
  final ApiService _apiService;
  final Obs<DriverTripStartOtpUiState> uiState = Obs<DriverTripStartOtpUiState>(
    DriverTripStartOtpUiState.empty(),
  );
  DriverTripStartOtpUiState get currentUiState => uiState.value;
  DriverTripStartOtpPresenter(this._socketService, this._apiService);

  void initialize(RideRequestModel rideRequest) {
    appLog(
      "Initializing DriverTripStartOtpPresenter with rideId: ${rideRequest.rideId}, userId: ${rideRequest.id}",
    );

    // Ensure socket is connected before setting up listeners
    _ensureSocketConnection();

    // Make sure we're listening to the correct event
    String socketEventName = 'notification::${rideRequest.id}';
    appLog("Setting up main socket event listener for: $socketEventName");

    // Set up the socket listeners
    _setupSocketListeners(socketEventName);

    // Also check for socket connection issues
    if (!_socketService.isConnected) {
      appLog("WARNING: Socket not connected after initialization attempt!");
    }
  }

  void _ensureSocketConnection() {
    if (!_socketService.isConnected) {
      appLog("Socket not connected. Connecting now...");
      _socketService.connectToSocket();
      // Wait a moment to ensure connection is established
      Future.delayed(Duration(milliseconds: 500), () {
        appLog(
          "Socket connection status: ${_socketService.isConnected ? 'Connected' : 'Not connected'}",
        );
      });
    } else {
      appLog("Socket already connected");
    }
  }

  void _setupSocketListeners(String socketEventName) {
    if (currentUiState.rideId?.isEmpty ?? true) return;

    appLog("Setting up socket listeners for event: $socketEventName");

    // Remove existing listeners to avoid duplicates
    _socketService.off(socketEventName);

    // Setup fresh listener
    _socketService.on(socketEventName, _handleSocketNotification);

    appLog("Socket listeners setup complete");
  }

  void _handleSocketNotification(dynamic data) {
    appLog("Notification received: $data");
    // Handle ride progress notification
    if (data is Map<String, dynamic> && data['rideProgress'] == true) {
      appLog("Ride progress notification received: $data");
    }
  }

  Future<void> tripStart(RideRequestModel rideRequest, String otp) async {
    //uiState.value = currentUiState.copyWith(isRideProcessing: true);
    final response = await _apiService.post(
      ApiEndPoint.startMatchedRide + rideRequest.rideId,
      body: {"rideId": rideRequest.rideId, "otp": otp},
    );
    response.fold(
      (failure) {
        uiState.value = currentUiState.copyWith(
          isLoading: false,
          userMessage: failure.message,
        );
        CustomToast(message: failure.message);
      },
      (success) {
        uiState.value = currentUiState.copyWith(
          isLoading: false,
          userMessage: success.message,
        );
        Get.off(() => RidesharePage(rideRequest: rideRequest));
        CustomToast(message: success.message!);
      },
    );
  }

  Future<void> onStartedPressed(
    BuildContext context,
    RideRequestModel rideRequest,
  ) async {
    String socketEventName = 'notification::${rideRequest.id}';
    appLog("Socket event name: $socketEventName");

    // Ensure socket is connected
    _ensureSocketConnection();

    // Remove any existing listeners to avoid duplicates
    _socketService.off(socketEventName);

    // Add listener for ride progress
    _socketService.on(socketEventName, (data) {
      appLog("Data received in onStartedPressed: $data");
      if (data is Map<String, dynamic> && data['rideProgress'] == true) {
        appLog("Ride progress:==========>>>>>>>*** $data");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RidesharePage(rideRequest: rideRequest),
          ),
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
}
