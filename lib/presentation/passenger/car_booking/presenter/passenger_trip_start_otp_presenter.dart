import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/passenger_trip_start_otp_ui_state.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/ride_share_screen.dart';
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
    uiState.value = currentUiState.copyWith(
      rideId: rideId,
      chatId: chatId,
      otp: otp,
      rideResponse: rideResponse,
    );
    String socketEventName = 'notification::${rideResponse.data.userId}';
    _ensureSocketConnection();
    _setupSocketListeners(socketEventName);
  }

  void _ensureSocketConnection() {
    _socketService.connectToSocket();
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
  }

  Future<void> onStartedPressed(
    BuildContext context,
    String rideId,
    RideResponseModel rideResponse,
    String chatId,
  ) async {
    String socketEventName = 'notification::${rideResponse.data.userId}';
    appLog("Socket event name: $socketEventName");
    _socketService.on(socketEventName, (data) {
      appLog("Data: $data");
      if (data is Map<String, dynamic> && data['rideProgress'] == true) {
        appLog("Ride progress:==========>>>>>>>*** $data");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RideShareScreen(
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
