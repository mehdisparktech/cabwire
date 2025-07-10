import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/domain/usecases/passenger/cencel_ride_usecase.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/ride_share_screen.dart';
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
  bool _isListeningToSocket = false;

  FindingRidesPresenter(this._socketService, this._cancelRideUseCase);

  void initialize(String rideId) {
    this.rideId = rideId;
    _ensureSocketConnection();
    _setupSocketListeners();
    _startReconnectMonitor();
  }

  void _ensureSocketConnection() {
    appLog("Checking socket connection...");
    if (!_socketService.isConnected) {
      appLog("Socket not connected. Connecting...");
      _socketService.connectToSocket();
    }
  }

  void _startReconnectMonitor() {
    appLog("Starting reconnect monitor...");
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_socketService.isConnected) {
        appLog("Socket disconnected. Attempting to reconnect...");
        _socketService.connectToSocket();
        if (!_isListeningToSocket) {
          _setupSocketListeners();
        }
      }
    });
  }

  void _setupSocketListeners() {
    appLog("Setting up socket listeners...");
    if (rideId == null) return;

    appLog("Setting up socket listeners for event: notification::$rideId");

    _isListeningToSocket = true;
    final eventName = 'notification::$rideId';
    appLog("Setting up socket listeners for event: $eventName");

    // Listen for general notifications
    _socketService.on(eventName, (data) {
      appLog("Socket connected: ${_socketService.isConnected}");
      appLog("Notification received: $data");

      // Handle different types of notifications based on data content
      if (data is Map<String, dynamic>) {
        // Handle driver acceptance
        if (data.containsKey('driverId') && data.containsKey('driverName')) {
          _handleDriverAcceptance(data);
        }
        // Handle driver location updates
        else if (data.containsKey('lat') && data.containsKey('lng')) {
          _handleDriverLocationUpdate(data);
        }
        // Handle ride status changes
        else if (data.containsKey('status')) {
          _handleRideStatusChange(data);
        }
        // Handle general messages
        else if (data.containsKey('message')) {
          showMessage(message: data['message']);
        }
      }
    });
    appLog("Socket listeners setup complete");
  }

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

  void _handleDriverLocationUpdate(Map<String, dynamic> data) {
    final driverLat = data['lat'] as double;
    final driverLng = data['lng'] as double;

    uiState.value = currentUiState.copyWith(
      driverLocation: LatLng(driverLat, driverLng),
    );

    // Update map markers if needed
    _updateDriverMarker(LatLng(driverLat, driverLng));
  }

  void _handleRideStatusChange(Map<String, dynamic> data) {
    appLog("Ride status changed: $data");
    final status = data['status'];

    if (status == 'started') {
      uiState.value = currentUiState.copyWith(isRideStarted: true);
      showMessage(message: 'Your ride has started!');
    }
  }

  void _updateDriverMarker(LatLng position) {
    // Logic to update driver marker on the map
    if (currentUiState.mapController != null) {
      // Update marker logic here
    }
  }

  void navigateToRideShareScreen(
    BuildContext context,
    String rideId,
    RideResponseModel rideResponse,
  ) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) =>
                RideShareScreen(rideId: rideId, rideResponse: rideResponse),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);
  }

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

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    if (rideId != null) {
      final eventName = 'notification::$rideId';
      _socketService.off(eventName);
      _isListeningToSocket = false;
      appLog("Socket listener removed for event: $eventName");
    }
    super.dispose();
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
