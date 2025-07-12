// ignore_for_file: unused_element

import 'dart:async';
import 'dart:math' as math;

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/static/constants.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/usecases/location/get_location_updates_usecase.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_close_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'ride_share_ui_state.dart';

class RideSharePresenter extends BasePresenter<RideShareUiState> {
  final ApiService _apiService = locate<ApiService>();
  final SocketService _socketService = locate<SocketService>();
  final GetCurrentLocationUsecase _getCurrentLocationUsecase =
      locate<GetCurrentLocationUsecase>();
  final GetLocationUpdatesUsecase _getLocationUpdatesUsecase =
      locate<GetLocationUpdatesUsecase>();
  Timer? _reconnectTimer;
  final PolylinePoints _polylinePoints = PolylinePoints();
  StreamSubscription? _locationSubscription;

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

  @override
  void onClose() {
    _locationSubscription?.cancel();
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

  void init({required String rideId, required rideResponse}) {
    uiState.value = RideShareUiState.empty(
      rideId: rideId,
      rideResponse: rideResponse,
    );
    _initialize();
  }

  void _initialize() {
    _ensureSocketConnection();
    _setCustomIcons();
    _initializeLocations();
    _getCurrentUserLocation();
    _startLocationUpdates();

    // Add a small delay to ensure socket is connected before setting up listeners
    Future.delayed(const Duration(milliseconds: 500), () {
      _setupSocketListeners();
    });

    _startReconnectMonitor();
  }

  Future<void> _getCurrentUserLocation() async {
    final result = await _getCurrentLocationUsecase.execute();
    result.fold(
      (error) {
        appLog("Error getting current location: $error");
      },
      (location) {
        final currentLatLng = LatLng(location.latitude, location.longitude);
        uiState.value = currentUiState.copyWith(
          currentUserLocation: currentLatLng,
        );
        _setMapMarkers();
      },
    );
  }

  void _startLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = _getLocationUpdatesUsecase.execute().listen(
      (result) {
        result.fold(
          (error) {
            appLog("Location update error: $error");
          },
          (location) {
            final newLocation = LatLng(location.latitude, location.longitude);

            // Calculate heading if we have a previous location
            double heading = currentUiState.userHeading;
            if (currentUiState.currentUserLocation != null) {
              heading = _calculateBearing(
                currentUiState.currentUserLocation!,
                newLocation,
              );
            }

            uiState.value = currentUiState.copyWith(
              currentUserLocation: newLocation,
              userHeading: heading,
            );

            _setMapMarkers();
          },
        );
      },
      onError: (e) {
        appLog("Error in location subscription: $e");
      },
    );
  }

  void _initializeLocations() {
    if (currentUiState.rideResponse == null) return;

    try {
      final pickupLocation = currentUiState.rideResponse!.data.pickupLocation;
      final dropoffLocation = currentUiState.rideResponse!.data.dropoffLocation;

      final pickupLatLng = LatLng(pickupLocation.lat, pickupLocation.lng);

      final dropoffLatLng = LatLng(dropoffLocation.lat, dropoffLocation.lng);

      uiState.value = currentUiState.copyWith(
        sourceMapCoordinates: pickupLatLng,
        destinationMapCoordinates: dropoffLatLng,
      );

      // Initialize markers and polyline
      _setMapMarkers();
      _generatePolyline();
    } catch (e) {
      appLog("Error initializing locations: $e");
    }
  }

  Future<void> _setCustomIcons() async {
    try {
      // Set pickup location icon
      await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        AppAssets.icLocationActive,
      ).then((value) {
        uiState.value = currentUiState.copyWith(sourceIcon: value);
      });

      // Set dropoff location icon
      await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        AppAssets.icLocationActive,
      ).then((value) {
        uiState.value = currentUiState.copyWith(destinationIcon: value);
      });

      // Set driver icon
      await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 80)),
        AppAssets.icMyCar,
      ).then((value) {
        uiState.value = currentUiState.copyWith(driverIcon: value);
      });

      // Set user location icon
      await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(50, 80)),
        AppAssets.icMyCar,
      ).then((value) {
        uiState.value = currentUiState.copyWith(userLocationIcon: value);
      });

      // Update markers with the custom icons
      _setMapMarkers();
    } catch (e) {
      appLog("Error setting custom icons: $e");
    }
  }

  void _setMapMarkers() {
    final Set<Marker> markers = {};

    // Add pickup marker
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: currentUiState.sourceMapCoordinates,
        icon: currentUiState.sourceIcon,
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet:
              currentUiState.rideResponse?.data.pickupLocation.address ?? '',
        ),
      ),
    );

    // Add dropoff marker
    markers.add(
      Marker(
        markerId: const MarkerId('dropoff'),
        position: currentUiState.destinationMapCoordinates,
        icon: currentUiState.destinationIcon,
        infoWindow: InfoWindow(
          title: 'Dropoff Location',
          snippet:
              currentUiState.rideResponse?.data.dropoffLocation.address ?? '',
        ),
      ),
    );

    // Add driver marker if available
    if (currentUiState.driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: currentUiState.driverLocation!,
          icon: currentUiState.driverIcon,
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
      );
    }

    // Add user's current location marker if available
    if (currentUiState.currentUserLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: currentUiState.currentUserLocation!,
          icon: currentUiState.userLocationIcon,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          rotation: currentUiState.userHeading,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    uiState.value = currentUiState.copyWith(markers: markers);
  }

  Future<void> _generatePolyline() async {
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

      if (polylineResult.points.isEmpty) {
        appLog("No route points returned from API");

        // If no route is available, create a straight line
        uiState.value = currentUiState.copyWith(
          polylineCoordinates: [
            currentUiState.sourceMapCoordinates,
            currentUiState.destinationMapCoordinates,
          ],
        );
        return;
      }

      // Convert points to LatLng list
      final List<LatLng> polylineCoordinates =
          polylineResult.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

      uiState.value = currentUiState.copyWith(
        polylineCoordinates: polylineCoordinates,
      );

      appLog(
        "Successfully generated polyline with ${polylineCoordinates.length} points",
      );
    } catch (e) {
      appLog("Error generating polyline: $e");
    }
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

      if (data.containsKey('rideProgress') && data['rideProgress'] == true) {
        appLog("Ride processing event received: $data");
        _handleRideProcessing(data);
      }

      // Handle different types of notifications based on data content
      // if (data is Map<String, dynamic>) {
      //   // Handle ride start event
      //   if (data.containsKey('rideStart') && data['rideStart'] == true) {
      //     _handleRideStart(data);
      //   }
      //   // Handle ride processing event
      //   else if (data.containsKey('rideProgress') &&
      //       data['rideProgress'] == true) {
      //     appLog("Ride processing event received: $data");
      //     _handleRideProcessing(data);
      //   }
      //   // Handle ride end event
      //   else if (data.containsKey('rideEnd') && data['rideEnd'] == true) {
      //     _handleRideEnd(data);
      //   }
      //   // Handle driver location updates
      //   else if (data.containsKey('lat') && data.containsKey('lng')) {
      //     _handleDriverLocationUpdate(data);
      //   }
      //   // Handle general messages
      //   else if (data.containsKey('message') || data.containsKey('text')) {
      //     String message =
      //         data.containsKey('text') ? data['text'] : data['message'];
      //     showMessage(message: message);
      //   }
      // }
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
    uiState.value = currentUiState.copyWith(
      isRideProcessing: true,
      isRideStart: false,
    );

    // Show message if available
    if (data.containsKey('message') || data.containsKey('text')) {
      String message =
          data.containsKey('text') ? data['text'] : data['message'];
      showMessage(message: message);
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

    // Update the driver location in the state
    uiState.value = currentUiState.copyWith(driverLocation: driverLocation);

    // Update the map markers with the new driver location
    _setMapMarkers();

    // Update map view if controller is available
    if (currentUiState.mapController != null) {
      currentUiState.mapController!.animateCamera(
        CameraUpdate.newLatLng(driverLocation),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);

    // Move camera to show both pickup and dropoff locations
    _fitMapToBounds();
  }

  void _fitMapToBounds() {
    if (currentUiState.mapController == null) return;

    try {
      // Create a bounds that includes both pickup and dropoff locations
      final bounds = LatLngBounds(
        southwest: LatLng(
          currentUiState.sourceMapCoordinates.latitude <
                  currentUiState.destinationMapCoordinates.latitude
              ? currentUiState.sourceMapCoordinates.latitude
              : currentUiState.destinationMapCoordinates.latitude,
          currentUiState.sourceMapCoordinates.longitude <
                  currentUiState.destinationMapCoordinates.longitude
              ? currentUiState.sourceMapCoordinates.longitude
              : currentUiState.destinationMapCoordinates.longitude,
        ),
        northeast: LatLng(
          currentUiState.sourceMapCoordinates.latitude >
                  currentUiState.destinationMapCoordinates.latitude
              ? currentUiState.sourceMapCoordinates.latitude
              : currentUiState.destinationMapCoordinates.latitude,
          currentUiState.sourceMapCoordinates.longitude >
                  currentUiState.destinationMapCoordinates.longitude
              ? currentUiState.sourceMapCoordinates.longitude
              : currentUiState.destinationMapCoordinates.longitude,
        ),
      );

      // Add some padding
      currentUiState.mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    } catch (e) {
      appLog("Error fitting map to bounds: $e");
    }
  }

  Future<void> requestCloseRide() async {
    toggleLoading(loading: true);
    final result = await _apiService.patch(
      ApiEndPoint.requestCloseRide +
          (currentUiState.rideResponse?.data.id ?? ''),
    );
    toggleLoading(loading: false);

    result.fold(
      (error) {
        CustomToast(message: error.message);
      },
      (success) {
        CustomToast(message: success.message ?? '');
        // Extract the OTP value from the nested data structure
        final otpData = success.data;
        appLog("OTP data: $otpData");
        final otp = otpData['data']['otp'].toString();
        appLog("OTP: $otp");
        Get.to(() => PassengerTripCloseOtpPage(otp: otp));
      },
    );
  }

  void handleTripClosureButtonPress() {
    if (currentUiState.isRideEnd) {
      requestCloseRide();
    } else {
      requestCloseRide();
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

  // Calculate the bearing/heading angle between two locations
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

    // Convert from radians to degrees
    return (((bearing * 180.0 / math.pi) + 360.0) % 360.0);
  }
}
