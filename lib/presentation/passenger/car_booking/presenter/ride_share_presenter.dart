import 'dart:async';

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_close_otp_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'ride_share_ui_state.dart';

class RideSharePresenter extends BasePresenter<RideShareUiState> {
  final ApiService _apiService = locate<ApiService>();
  final SocketService _socketService = locate<SocketService>();
  Timer? _reconnectTimer;

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

  void _setupSocketListeners() {
    appLog("Setting up socket listeners...");
    if (currentUiState.rideId.isEmpty) return;

    final eventName = 'notification::${currentUiState.rideId}';
    appLog("Setting up socket listeners for event: $eventName");

    // First, remove any existing listeners to avoid duplicates
    _socketService.off(eventName);

    // Setup fresh listener
    _socketService.on(eventName, (data) {
      appLog("Socket connected: ${_socketService.isConnected}");
      appLog("Notification received: $data");

      // Handle different types of notifications based on data content
      if (data is Map<String, dynamic>) {
        // Handle ride start event
        if (data.containsKey('rideStart') && data['rideStart'] == true) {
          _handleRideStart(data);
        }
        // Handle ride processing event
        else if (data.containsKey('rideProgress') &&
            data['rideProgress'] == true) {
          _handleRideProcessing(data);
        }
        // Handle ride end event
        else if (data.containsKey('rideEnd') && data['rideEnd'] == true) {
          _handleRideEnd(data);
        }
        // Handle driver location updates
        else if (data.containsKey('lat') && data.containsKey('lng')) {
          _handleDriverLocationUpdate(data);
        }
        // Handle general messages
        else if (data.containsKey('message') || data.containsKey('text')) {
          String message =
              data.containsKey('text') ? data['text'] : data['message'];
          showMessage(message: message);
        }
      }
    });

    appLog("Socket listeners setup complete for event: $eventName");
  }

  void _handleRideStart(Map<String, dynamic> data) {
    appLog("Ride start event received: $data");
    uiState.value = currentUiState.copyWith(isRideStart: true);

    // Show message if available
    if (data.containsKey('text')) {
      showMessage(message: data['text']);
    } else if (data.containsKey('message')) {
      showMessage(message: data['message']);
    } else {
      showMessage(message: 'Your ride has started!');
    }
  }

  void _handleRideProcessing(Map<String, dynamic> data) {
    appLog("Ride processing event received: $data");
    uiState.value = currentUiState.copyWith(isRideProcessing: true);

    // Show message if available
    if (data.containsKey('message')) {
      showMessage(message: data['message']);
    }
  }

  void _handleRideEnd(Map<String, dynamic> data) {
    appLog("Ride end event received: $data");
    uiState.value = currentUiState.copyWith(
      isRideProcessing: false,
      isRideEnd: true,
    );

    // Show message if available
    if (data.containsKey('message')) {
      showMessage(message: data['message']);
    } else {
      showMessage(message: 'Your ride has ended!');
    }
  }

  void _handleDriverLocationUpdate(Map<String, dynamic> data) {
    final driverLat = data['lat'] as double;
    final driverLng = data['lng'] as double;
    final driverLocation = LatLng(driverLat, driverLng);

    // Create or update driver marker
    final driverMarker = Marker(
      markerId: const MarkerId('driver_marker'),
      position: driverLocation,
      infoWindow: const InfoWindow(title: 'Driver Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    // Create a new set with the updated driver marker
    final updatedMarkers = Set<Marker>.from(currentUiState.markers);

    // Remove any existing driver marker and add the new one
    updatedMarkers.removeWhere(
      (marker) => marker.markerId.value == 'driver_marker',
    );
    updatedMarkers.add(driverMarker);

    // Update the state
    uiState.value = currentUiState.copyWith(
      driverLocation: driverLocation,
      markers: updatedMarkers,
    );

    // Update map view if controller is available
    if (currentUiState.mapController != null) {
      currentUiState.mapController!.animateCamera(
        CameraUpdate.newLatLng(driverLocation),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);
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
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    // Remove socket listeners
    if (currentUiState.rideId.isNotEmpty) {
      final eventName = 'notification::${currentUiState.rideId}';
      _socketService.off(eventName);
      appLog("Socket listener removed for event: $eventName");
    }

    currentUiState.mapController?.dispose();
    super.onClose();
  }
}
