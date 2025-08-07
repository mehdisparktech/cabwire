import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/passenger_trip_start_otp_ui_state.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_ride_share_screen.dart';
import 'package:flutter/material.dart';

class PassengerTripStartOtpPresenter
    extends BasePresenter<PassengerTripStartOtpUiState> {
  final SocketService _socketService;
  final Obs<PassengerTripStartOtpUiState> uiState =
      Obs<PassengerTripStartOtpUiState>(PassengerTripStartOtpUiState.empty());
  PassengerTripStartOtpUiState get currentUiState => uiState.value;
  PassengerTripStartOtpPresenter(this._socketService);

  void initialize(
    String rideId,
    String chatId,
    String otp,
    RideResponseModel rideResponse,
  ) {
    appLog(
      "Initializing PassengerTripStartOtpPresenter with rideId: $rideId, userId: ${rideResponse.data.userId}",
    );

    uiState.value = currentUiState.copyWith(
      rideId: rideId,
      chatId: chatId,
      otp: otp,
      rideResponse: rideResponse,
    );

    // Ensure socket is connected before setting up listeners
    _ensureSocketConnection();

    // Make sure we're listening to the correct event
    String socketEventName = 'notification::${rideResponse.data.userId}';
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

  Future<void> onStartedPressed(
    BuildContext context,
    String rideId,
    RideResponseModel rideResponse,
    String chatId,
  ) async {
    String socketEventName = 'notification::${rideResponse.data.userId}';
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
            builder:
                (context) => PassengerRideShareScreen(
                  rideId: rideId,
                  rideResponse: rideResponse,
                  chatId: chatId,
                  isRideProcessing: true,
                ),
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
