import 'dart:async';
import 'dart:math' as math;

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/static/constants.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/usecases/location/get_location_updates_usecase.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/chat_page.dart';
import 'package:cabwire/presentation/driver/home/presenter/rideshare_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/driver_trip_close_otp_page.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/driver_trip_start_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidesharePresenter extends BasePresenter<RideshareUiState> {
  // Constants
  static const double _defaultPickupSpeedKmh = 25.0;
  static const double _defaultRideSpeedKmh = 30.0;
  static const double _earthRadiusMeters = 6371000;
  static const Duration _reconnectInterval = Duration(seconds: 5);
  static const Duration _timeUpdateInterval = Duration(seconds: 10);
  static const Duration _socketSetupDelay = Duration(milliseconds: 500);

  // Services
  final ApiService apiService;
  final SocketService _socketService;
  final GetCurrentLocationUsecase _getCurrentLocationUsecase;
  final GetLocationUpdatesUsecase _getLocationUpdatesUsecase;
  final PolylinePoints _polylinePoints = PolylinePoints();

  // Timers and Subscriptions
  Timer? _rideStartTimer;
  Timer? _reconnectTimer;
  Timer? _timeUpdateTimer;
  StreamSubscription? _locationSubscription;

  // UI State
  final Obs<RideshareUiState> uiState = Obs<RideshareUiState>(
    RideshareUiState.initial(),
  );
  RideshareUiState get currentUiState => uiState.value;

  RidesharePresenter(
    this.apiService,
    this._socketService,
    this._getCurrentLocationUsecase,
    this._getLocationUpdatesUsecase,
  ) {
    _initialize();
  }

  void _initialize() {
    _startRideTimer();
    _ensureSocketConnection();
    _setCustomIcons();
    _getCurrentUserLocation();
    _startLocationUpdates();
    _startTimeUpdates();
    _startReconnectMonitor();

    // Delay socket setup to ensure connection
    Future.delayed(_socketSetupDelay, _setupSocketListeners);
  }

  void setRideRequest(RideRequestModel rideRequest, String chatId) {
    uiState.value = currentUiState.copyWith(
      rideRequest: rideRequest,
      mapCenter: rideRequest.pickupLocation,
      sourceMapCoordinates: rideRequest.pickupLocation,
      destinationMapCoordinates: rideRequest.dropoffLocation,
      socketEventName: 'notification::${rideRequest.userId}',
      chatId: chatId,
    );
    _initializeLocations();
  }

  void setRideProgress(bool rideProgress) {
    if (rideProgress) {
      uiState.value = currentUiState.copyWith(
        isRideProcessing: true,
        isRideStart: true, // Set to false to match passenger logic
      );

      // Send current driver location immediately to ensure passenger has latest location
      if (currentUiState.currentUserLocation != null) {
        _sendDriverLocationUpdate(currentUiState.currentUserLocation!);
      }

      // Wait a moment for location to be sent, then calculate time
      Future.delayed(Duration(milliseconds: 200), () {
        _updateEstimatedTimeRemaining();
      });
    }
  }

  void _startRideTimer() {
    _rideStartTimer = Timer(const Duration(seconds: 5), () {
      uiState.value = currentUiState.copyWith(isRideStart: true);
    });
  }

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);
    _fitMapToBounds();
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
        Get.off(
          () => DriverTripStartOtpPage(
            rideRequest: currentUiState.rideRequest!,
            chatId: currentUiState.chatId,
          ),
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

    // Store rideId before navigating
    final rideId = currentUiState.rideRequest!.rideId;

    // Reset UI state to initial state
    _resetUIState();

    Get.off(() => DriverTripCloseOtpPage(rideId: rideId));
  }

  // Reset UI state to initial when closing a trip
  void _resetUIState() {
    // Cancel all timers and subscriptions
    _cleanup();

    // Reset to initial state but keep custom icons and current location
    final currentLocation = currentUiState.currentUserLocation;
    final sourceIcon = currentUiState.sourceIcon;
    final destinationIcon = currentUiState.destinationIcon;
    final driverIcon = currentUiState.driverIcon;
    final userLocationIcon = currentUiState.userLocationIcon;

    // Set UI state back to initial state
    uiState.value = RideshareUiState.initial().copyWith(
      sourceIcon: sourceIcon,
      destinationIcon: destinationIcon,
      driverIcon: driverIcon,
      userLocationIcon: userLocationIcon,
      currentUserLocation: currentLocation,
      driverLocation: currentLocation,
      isRideStart: false,
      isRideProcessing: false,
      isRideEnd: false,
    );

    // Restart necessary components for next trip
    _startLocationUpdates();
    _startTimeUpdates();
    _startReconnectMonitor();
  }

  /// Public method to reset UI state that can be called from outside
  void resetUIState() {
    _resetUIState();
  }

  void navigateToChat() {
    Get.to(() => ChatPage(chatId: currentUiState.chatId));
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
    _cleanup();
    super.onClose();
  }

  void _cleanup() {
    _locationSubscription?.cancel();
    _reconnectTimer?.cancel();
    _timeUpdateTimer?.cancel();
    _rideStartTimer?.cancel();

    if (currentUiState.rideRequest != null) {
      _socketService.off(currentUiState.socketEventName);
      appLog(
        "Socket listener removed for event: ${currentUiState.socketEventName}",
      );
    }

    currentUiState.mapController?.dispose();
  }

  // ===== Location Management =====

  Future<void> _getCurrentUserLocation() async {
    final result = await _getCurrentLocationUsecase.execute();
    result.fold((error) => appLog("Error getting current location: $error"), (
      location,
    ) {
      final currentLatLng = LatLng(location.latitude, location.longitude);
      uiState.value = currentUiState.copyWith(
        currentUserLocation: currentLatLng,
        driverLocation: currentLatLng, // Driver's current location
      );
      _setMapMarkers();
    });
  }

  void _startLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = _getLocationUpdatesUsecase.execute().listen((
      result,
    ) {
      result.fold(
        (error) => appLog("Location update error: $error"),
        (location) => _handleLocationUpdate(location),
      );
    }, onError: (e) => appLog("Error in location subscription: $e"));
  }

  void _handleLocationUpdate(location) {
    final newLocation = LatLng(location.latitude, location.longitude);
    double heading = currentUiState.userHeading;

    if (currentUiState.currentUserLocation != null) {
      heading = _calculateBearing(
        currentUiState.currentUserLocation!,
        newLocation,
      );
    }

    uiState.value = currentUiState.copyWith(
      currentUserLocation: newLocation,
      driverLocation: newLocation, // Update driver location
      userHeading: heading,
      currentSpeed: location.speed,
    );

    appLog(
      "Current speed: ${location.speed?.toStringAsFixed(2) ?? 'unavailable'} m/s",
    );

    _updateEstimatedTimeRemaining();
    _setMapMarkers();

    // Send driver location update via socket
    _sendDriverLocationUpdate(newLocation);
  }

  void _initializeLocations() {
    if (currentUiState.rideRequest == null) return;

    try {
      final pickupLocation = currentUiState.rideRequest!.pickupLocation;
      final dropoffLocation = currentUiState.rideRequest!.dropoffLocation;

      final estimatedTime = _calculateInitialEstimatedTime(
        pickupLocation,
        dropoffLocation,
      );

      uiState.value = currentUiState.copyWith(
        sourceMapCoordinates: pickupLocation,
        destinationMapCoordinates: dropoffLocation,
        timerLeft: estimatedTime.inMinutes,
        estimatedTimeInSeconds: estimatedTime.inSeconds,
      );

      _setMapMarkers();
      _generatePolyline();
    } catch (e) {
      appLog("Error initializing locations: $e");
    }
  }

  // ===== Time Calculation Methods =====

  void _startTimeUpdates() {
    _timeUpdateTimer?.cancel();
    _timeUpdateTimer = Timer.periodic(
      _timeUpdateInterval,
      (_) => _updateEstimatedTimeRemaining(),
    );
  }

  void _updateEstimatedTimeRemaining() {
    if (currentUiState.currentUserLocation == null) return;

    final targetInfo = _getTargetLocationInfo();
    if (targetInfo == null) return;

    appLog("Driver location: ${currentUiState.currentUserLocation}");
    appLog("Target location: ${targetInfo.location}");
    appLog("Ride processing: ${currentUiState.isRideProcessing}");

    final distanceInMeters = _calculateDistance(
      currentUiState.currentUserLocation!,
      targetInfo.location,
    );

    final estimatedTime = _calculateEstimatedTime(
      distanceInMeters,
      targetInfo.averageSpeed,
    );

    if (_hasTimeChanged(estimatedTime)) {
      uiState.value = currentUiState.copyWith(
        timerLeft: estimatedTime.inMinutes,
        estimatedTimeInSeconds: estimatedTime.inSeconds,
      );
    }
  }

  ({LatLng location, double averageSpeed})? _getTargetLocationInfo() {
    if (currentUiState.isRideProcessing) {
      // When ride is in progress, target is the destination
      return (
        location: currentUiState.destinationMapCoordinates,
        averageSpeed: _getSpeed(_defaultRideSpeedKmh),
      );
    } else {
      // When going to pickup passenger or ride is ready to start
      return (
        location: currentUiState.sourceMapCoordinates,
        averageSpeed: _getSpeed(_defaultPickupSpeedKmh),
      );
    }
  }

  double _getSpeed(double defaultSpeedKmh) {
    final minSpeedMps =
        2.0; // Minimum 2 m/s (7.2 km/h) to avoid unrealistic calculations

    if (currentUiState.currentSpeed != null &&
        currentUiState.currentSpeed! > minSpeedMps) {
      appLog(
        "[DRIVER] Using real-time speed: ${currentUiState.currentSpeed!.toStringAsFixed(2)} m/s",
      );
      return currentUiState.currentSpeed!;
    }
    final speedMps = defaultSpeedKmh / 3.6;
    appLog(
      "[DRIVER] Using default speed: ${speedMps.toStringAsFixed(2)} m/s ($defaultSpeedKmh km/h)",
    );
    return speedMps;
  }

  Duration _calculateEstimatedTime(double distanceMeters, double speedMps) {
    final seconds = (distanceMeters / speedMps).round();
    appLog(
      "Distance: ============= ******* ${distanceMeters.toStringAsFixed(0)}m, Time: ${(seconds / 60).ceil()} minutes",
    );
    return Duration(seconds: seconds);
  }

  Duration _calculateInitialEstimatedTime(LatLng pickup, LatLng dropoff) {
    appLog("Location*****++++++++  $pickup  and  =========*****  $dropoff");
    final distance = _calculateDistance(pickup, dropoff);
    const averageSpeedMps = 8.33; // 30 km/h
    return _calculateEstimatedTime(distance, averageSpeedMps);
  }

  bool _hasTimeChanged(Duration newTime) {
    return newTime.inMinutes != currentUiState.timerLeft ||
        newTime.inSeconds != currentUiState.estimatedTimeInSeconds;
  }

  // ===== Map & UI Methods =====

  Future<void> _setCustomIcons() async {
    try {
      final icons = await Future.wait([
        _loadIcon(AppAssets.icLocationActive, const Size(50, 50)),
        _loadIcon(AppAssets.icLocationActive, const Size(50, 50)),
        _loadIcon(AppAssets.icMyCar, const Size(50, 80)),
        _loadIcon(AppAssets.icMyCar, const Size(50, 80)),
      ]);

      uiState.value = currentUiState.copyWith(
        sourceIcon: icons[0],
        destinationIcon: icons[1],
        driverIcon: icons[2],
        userLocationIcon: icons[3],
      );

      _setMapMarkers();
    } catch (e) {
      appLog("Error setting custom icons: $e");
    }
  }

  Future<BitmapDescriptor> _loadIcon(String asset, Size size) async {
    return await BitmapDescriptor.asset(ImageConfiguration(size: size), asset);
  }

  void _setMapMarkers() {
    if (currentUiState.rideRequest == null) return;

    final markers = <Marker>{
      _createMarker(
        id: 'pickup',
        position: currentUiState.sourceMapCoordinates,
        icon: currentUiState.sourceIcon,
        title: 'Pickup Location',
        snippet: currentUiState.rideRequest!.pickupAddress,
      ),
      _createMarker(
        id: 'dropoff',
        position: currentUiState.destinationMapCoordinates,
        icon: currentUiState.destinationIcon,
        title: 'Dropoff Location',
        snippet: currentUiState.rideRequest!.dropoffAddress,
      ),
    };

    // if (currentUiState.driverLocation != null) {
    //   markers.add(
    //     _createMarker(
    //       id: 'driver',
    //       position: currentUiState.driverLocation!,
    //       icon: currentUiState.driverIcon,
    //       title: 'Driver Location',
    //     ),
    //   );
    // }

    if (currentUiState.driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: currentUiState.driverLocation!,
          icon: currentUiState.driverIcon,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          rotation: currentUiState.userHeading,
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
      );
    }

    uiState.value = currentUiState.copyWith(markers: markers);
  }

  Marker _createMarker({
    required String id,
    required LatLng position,
    required BitmapDescriptor icon,
    required String title,
    String? snippet,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(title: title, snippet: snippet),
    );
  }

  Future<void> _generatePolyline() async {
    if (currentUiState.rideRequest == null) return;

    try {
      final polylineResult = await _polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(
            currentUiState.sourceMapCoordinates.latitude,
            currentUiState.sourceMapCoordinates.longitude,
          ),
          destination: PointLatLng(
            currentUiState.destinationMapCoordinates.latitude,
            currentUiState.destinationMapCoordinates.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      final polylineCoordinates =
          polylineResult.points.isEmpty
              ? [
                currentUiState.sourceMapCoordinates,
                currentUiState.destinationMapCoordinates,
              ]
              : polylineResult.points
                  .map((p) => LatLng(p.latitude, p.longitude))
                  .toList();

      uiState.value = currentUiState.copyWith(
        polylineCoordinates: polylineCoordinates,
      );
      appLog("Generated polyline with ${polylineCoordinates.length} points");
    } catch (e) {
      appLog("Error generating polyline: $e");
    }
  }

  void _fitMapToBounds() {
    if (currentUiState.mapController == null ||
        currentUiState.rideRequest == null) {
      return;
    }

    try {
      final bounds = _calculateBounds(
        currentUiState.sourceMapCoordinates,
        currentUiState.destinationMapCoordinates,
      );
      currentUiState.mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    } catch (e) {
      appLog("Error fitting map to bounds: $e");
    }
  }

  LatLngBounds _calculateBounds(LatLng point1, LatLng point2) {
    return LatLngBounds(
      southwest: LatLng(
        math.min(point1.latitude, point2.latitude),
        math.min(point1.longitude, point2.longitude),
      ),
      northeast: LatLng(
        math.max(point1.latitude, point2.latitude),
        math.max(point1.longitude, point2.longitude),
      ),
    );
  }

  // ===== Socket Management =====

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
    _reconnectTimer = Timer.periodic(_reconnectInterval, (_) {
      if (!_socketService.isConnected) {
        appLog("Socket disconnected. Attempting to reconnect...");
        _socketService.connectToSocket();
        _setupSocketListeners();
      }
    });
  }

  void _setupSocketListeners() {
    if (currentUiState.rideRequest == null) return;

    appLog(
      "Setting up socket listeners for event: ${currentUiState.socketEventName}",
    );

    // Remove existing listeners to avoid duplicates
    _socketService.off(currentUiState.socketEventName);

    // Setup fresh listener
    _socketService.on(
      currentUiState.socketEventName,
      _handleSocketNotification,
    );

    appLog("Socket listeners setup complete");
  }

  void _handleSocketNotification(dynamic data) {
    appLog("Notification received: $data");

    if (data is! Map<String, dynamic>) return;

    try {
      // Handle passenger location updates
      if (_isPassengerLocationUpdate(data)) {
        _handlePassengerLocationUpdate(data);
      }
      if (data['dropoffLocation'] != null &&
          currentUiState.rideRequest != null) {
        final drop = data['dropoffLocation'] as Map<String, dynamic>;
        final fare = data['fare'] as num?;
        final distance = data['distance'] as num?;
        final previous = currentUiState.rideRequest!;
        final previousDrop = previous.dropoffLocation;

        final updatedAddress =
            (drop['address'] as String?) ?? previous.dropoffAddress;
        final updatedLat =
            ((drop['lat'] as num?)?.toDouble()) ?? previousDrop.latitude;
        final updatedLng =
            ((drop['lng'] as num?)?.toDouble()) ?? previousDrop.longitude;
        final updatedFare = (fare ?? previous.fare).toDouble();
        final updatedDistance = (distance ?? previous.distance).toDouble();

        final hasChanged =
            updatedAddress != previous.dropoffAddress ||
            updatedLat != previousDrop.latitude ||
            updatedLng != previousDrop.longitude;

        if (hasChanged) {
          final updatedModel = RideRequestModel(
            id: previous.id,
            userId: previous.userId,
            rideId: previous.rideId,
            service: previous.service,
            pickupLocation: previous.pickupLocation,
            pickupAddress: previous.pickupAddress,
            dropoffLocation: LatLng(updatedLat, updatedLng),
            dropoffAddress: updatedAddress,
            fare: updatedFare,
            distance: updatedDistance,
            duration: previous.duration,
            createdAt: previous.createdAt,
          );

          applyRideUpdate(updatedModel);
        }
      }

      // Handle messages
      _handleMessageIfPresent(data);
    } catch (e) {
      appLog("Error processing notification: $e");
    }
  }

  bool _isPassengerLocationUpdate(Map<String, dynamic> data) {
    return data.containsKey('lat') && data.containsKey('lng');
  }

  void _handlePassengerLocationUpdate(Map<String, dynamic> data) {
    final passengerLocation = LatLng(
      data['lat'] as double,
      data['lng'] as double,
    );

    // You can add passenger location marker if needed
    appLog("Passenger location updated: $passengerLocation");
  }

  void _handleMessageIfPresent(Map<String, dynamic> data) {
    final message = data['text'] ?? data['message'];
    if (message != null) {
      CustomToast(message: message.toString());
    }
  }

  void _sendDriverLocationUpdate(LatLng location) {
    if (currentUiState.rideRequest == null) return;

    final locationData = {
      'lat': location.latitude,
      'lng': location.longitude,
      'rideId': currentUiState.rideRequest!.rideId,
      'passengerId':
          currentUiState.rideRequest!.userId, // This is the passenger ID
    };

    _socketService.emit('driverLocationUpdate', locationData);
    appLog("Driver location sent: $locationData");
  }

  // ===== Apply Ride Update =====

  void applyRideUpdate(RideRequestModel updated) {
    try {
      final newDestination = updated.dropoffLocation;

      uiState.value = currentUiState.copyWith(
        rideRequest: updated,
        destinationMapCoordinates: newDestination,
      );

      _setMapMarkers();
      _generatePolyline();
      _updateEstimatedTimeRemaining();
      _fitMapToBounds();
    } catch (e) {
      appLog("Error applying ride update: $e");
    }
  }

  // ===== Utility Methods =====

  double _calculateDistance(LatLng point1, LatLng point2) {
    final lat1 = point1.latitude * math.pi / 180;
    final lng1 = point1.longitude * math.pi / 180;
    final lat2 = point2.latitude * math.pi / 180;
    final lng2 = point2.longitude * math.pi / 180;

    final dLat = lat2 - lat1;
    final dLng = lng2 - lng1;

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return _earthRadiusMeters * c;
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final startLat = start.latitude * (math.pi / 180.0);
    final startLng = start.longitude * (math.pi / 180.0);
    final endLat = end.latitude * (math.pi / 180.0);
    final endLng = end.longitude * (math.pi / 180.0);

    final dLng = endLng - startLng;

    final y = math.sin(dLng) * math.cos(endLat);
    final x =
        math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(dLng);

    final bearing = math.atan2(y, x);

    return (((bearing * 180.0 / math.pi) + 360.0) % 360.0);
  }
}
