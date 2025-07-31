import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/domain/usecases/passenger/cencel_ride_usecase.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_start_otp_page.dart';
import 'package:cabwire/presentation/passenger/main/ui/screens/passenger_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'finding_rides_ui_state.dart';

class FindingRidesPresenter extends BasePresenter<FindingRidesUiState> {
  final SocketService _socketService;
  final CancelRideUseCase _cancelRideUseCase;
  final Obs<FindingRidesUiState> uiState = Obs<FindingRidesUiState>(
    FindingRidesUiState.initial(),
  );
  FindingRidesUiState get currentUiState => uiState.value;
  String? rideId;
  Timer? _reconnectTimer;

  FindingRidesPresenter(this._socketService, this._cancelRideUseCase);

  void initialize(String rideId) {
    this.rideId = rideId;
    appLog("Initializing with rideId: $rideId");
    _ensureSocketConnection();

    // Add a small delay to ensure socket is connected before setting up listeners
    Future.delayed(const Duration(milliseconds: 500), () {
      _setupSocketListeners();
    });

    _startReconnectMonitor();
  }

  void _ensureSocketConnection() {
    appLog("Checking socket connection...");
    if (!_socketService.isConnected) {
      appLog("Socket not connected. Connecting...");
      _socketService.connectToSocket();
    }
  }

  //start reconnect monitor
  void _startReconnectMonitor() {
    appLog("Starting reconnect monitor...");
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_socketService.isConnected) {
        appLog("Socket disconnected. Attempting to reconnect...");
        _socketService.connectToSocket();
        // Re-setup listeners after reconnection
        _setupSocketListeners();
      }
    });
  }

  //setup socket listeners
  void _setupSocketListeners() {
    appLog("Setting up socket listeners...");
    if (rideId == null) return;

    final eventName = 'notification::$rideId';
    appLog("Setting up socket listeners for event: $eventName");

    // First, remove any existing listeners to avoid duplicates
    _socketService.off(eventName);

    // Setup fresh listener

    // Listen for general notifications
    _socketService.on(eventName, (data) {
      appLog("Socket connected: ${_socketService.isConnected}");
      appLog("Notification received: $data");

      // Handle different types of notifications based on data content
      if (data is Map<String, dynamic>) {
        // Check for ride acceptance first (this is the main condition)
        if (data.containsKey('rideAccept') && data['rideAccept'] == true) {
          _handleRideAcceptance(data);
        }
        // Handle driver acceptance (if driver details are present)
        else if (data.containsKey('driverId') &&
            data.containsKey('driverName')) {
          _handleDriverAcceptance(data);
        }
        // Handle driver location updates
        else if (data.containsKey('lat') && data.containsKey('lng')) {
          _handleDriverLocationUpdate(data);
        }
        // Handle general messages
        else if (data.containsKey('message')) {
          showMessage(message: data['message']);
        }
      }
    });
    appLog("Socket listeners setup complete for event: $eventName");
  }

  //handle ride acceptance
  void _handleRideAcceptance(Map<String, dynamic> data) {
    appLog("Ride accepted event received: $data");

    if (data.containsKey('chat') && data['chat'] != null) {
      final chatData = data['chat'];
      if (chatData is Map<String, dynamic> && chatData.containsKey('_id')) {
        final chatId = chatData['_id'].toString();
        appLog("Chat ID extracted from ride acceptance: $chatId");
        uiState.value = currentUiState.copyWith(chatId: chatId);
      }
    }

    // Update UI state to indicate ride has been accepted
    uiState.value = currentUiState.copyWith(
      isRideAccepted: true,
      driverId: data['driverId']?.toString(),
      // Extract other driver details if available
      driverName: data['driverName']?.toString(),
      driverPhone: data['driverPhone']?.toString(),
      driverPhoto: data['driverPhoto']?.toString(),
      driverVehicle: data['driverVehicle']?.toString(),
    );

    // Show success message
    String message = data['text']?.toString() ?? 'Ride accepted successfully!';
    showMessage(message: message);

    appLog(
      "Updated UI state - isRideAccepted: ${currentUiState.isRideAccepted}",
    );
    appLog("Chat ID: ${currentUiState.chatId}");
  }

  //handle driver acceptance
  void _handleDriverAcceptance(Map<String, dynamic> data) {
    appLog("Driver accepted event received: $data");

    uiState.value = currentUiState.copyWith(
      isRideAccepted: true,
      driverId: data['driverId'],
      driverName: data['driverName'],
      driverPhone: data['driverPhone'],
      driverPhoto: data['driverPhoto'],
      driverVehicle: data['driverVehicle'],
    );

    showMessage(message: 'A driver has accepted your ride!');
  }

  //handle driver location update
  void _handleDriverLocationUpdate(Map<String, dynamic> data) {
    final driverLat = data['lat'] as double;
    final driverLng = data['lng'] as double;

    uiState.value = currentUiState.copyWith(
      driverLocation: LatLng(driverLat, driverLng),
    );

    // Update map markers if needed
    _updateDriverMarker(LatLng(driverLat, driverLng));
  }

  //handle ride status change
  // ignore: unused_element
  void _handleRideStatusChange(Map<String, dynamic> data) {
    appLog("Ride status changed: $data");
    final status = data['rideAccept'];

    if (status) {
      uiState.value = currentUiState.copyWith(isRideStarted: true);
      showMessage(message: 'Your ride has started!');
    }
  }

  //update driver marker
  void _updateDriverMarker(LatLng position) {
    // Logic to update driver marker on the map
    if (currentUiState.mapController != null) {
      // Update marker logic here
    }
  }

  //navigate to ride share screen
  void navigateToRideShareScreen(
    BuildContext context,
    String rideId,
    RideResponseModel rideResponse,
  ) {
    appLog("Navigating to RideShareScreen...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => PassengerTripStartOtpPage(
              rideId: rideId,
              rideResponse: rideResponse,
              //chatId: currentUiState.chatId ?? '',
              otp: '',
            ),
      ),
    );
  }

  //on map created
  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);
  }

  //cancel ride request
  Future<void> cancelRideRequest(BuildContext context, String id) async {
    if (id.isNotEmpty) {
      final result = await _cancelRideUseCase.execute(id);

      result.fold(
        (error) {
          showMessage(message: error.toString());
          Navigator.pop(context);
        },
        (success) {
          showMessage(message: success);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PassengerMainPage()),
            (route) => false,
          );
        },
      );
    } else {
      showMessage(message: 'Ride not found');
    }
  }

  //dispose
  @override
  void dispose() {
    appLog("Disposing FindingRidesPresenter...");

    // Cancel reconnect timer
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    // Remove socket listeners
    if (rideId != null) {
      final eventName = 'notification::$rideId';
      _socketService.off(eventName);
      appLog("Socket listener removed for event: $eventName");
    }

    // Clear rideId
    rideId = null;

    super.dispose();
  }

  //add user message
  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  //toggle loading
  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
