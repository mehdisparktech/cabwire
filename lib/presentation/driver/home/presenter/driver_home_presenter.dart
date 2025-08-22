import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/core/static/constants.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/entities/location_entity.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/domain/usecases/update_online_status_usecase.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/driver_rideshare_page.dart';
import 'package:cabwire/presentation/driver/main/ui/screens/driver_main_page.dart';
import 'package:cabwire/presentation/driver/notification/ui/screens/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePresenter extends BasePresenter<DriverHomeUiState> {
  final GetCurrentLocationUsecase getCurrentLocationUsecase;
  final UpdateOnlineStatusUseCase updateOnlineStatusUseCase;
  final SocketService socketService;
  final ApiService apiService;

  LocationEntity? location;
  Timer? _connectionMonitorTimer;

  final Obs<DriverHomeUiState> uiState = Obs<DriverHomeUiState>(
    DriverHomeUiState.initial(),
  );

  DriverHomeUiState get currentUiState => uiState.value;
  GoogleMapController? _mapController;

  DriverHomePresenter(
    this.getCurrentLocationUsecase,
    this.updateOnlineStatusUseCase,
    this.socketService,
    this.apiService,
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeFromArguments();
    await loadDriverProfile();
    await getCurrentLocation();
    setCustomIcons();
    if (location != null) {
      await setPolyline();
    }
    // Initialize socket connection
    _initializeSocketConnection();

    // If driver is already online (from arguments), ensure socket is properly connected
    if (currentUiState.isOnline) {
      debugPrint('Driver is already online, ensuring socket connection...');
      _ensureSocketConnectionForOnlineStatus();
    }
  }

  void _initializeSocketConnection() {
    if (!socketService.isConnected) {
      debugPrint('Socket not connected. Connecting to socket...');
      socketService.connectToSocket();
    }

    _setupSocketListener();
  }

  void _setupSocketListener() {
    final String driverId = LocalStorage.userId;
    if (driverId.isEmpty) {
      debugPrint('Driver ID is empty, cannot listen to notifications');
      return;
    }

    final String notificationEvent = 'notification::$driverId';
    debugPrint('Setting up socket listener for event: $notificationEvent');

    // First remove any existing listener to prevent duplicates
    socketService.off(notificationEvent);

    // Add the notification listener
    socketService.on(notificationEvent, (data) {
      debugPrint('=== Received notification data for driver: ===');
      debugPrint('Event: $notificationEvent');
      debugPrint('Data: $data');

      if (data is Map<String, dynamic>) {
        _processRideRequestData(data);
      } else {
        debugPrint('Received data is not a Map: ${data.runtimeType}');
      }
    });

    debugPrint('Socket listener setup complete for: $notificationEvent');
  }

  void _ensureSocketConnectionForOnlineStatus() {
    debugPrint('Driver going online - ensuring socket connection...');

    if (!socketService.isConnected) {
      debugPrint('Socket not connected. Connecting immediately...');
      socketService.connectToSocket();

      // Wait a moment for connection to establish, then setup listener
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (socketService.isConnected) {
          debugPrint('Socket connected successfully after going online');
          _setupSocketListener();
        } else {
          debugPrint('Socket still not connected after delay. Retrying...');
          socketService.connectToSocket();

          // One more attempt after another delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (socketService.isConnected) {
              debugPrint('Socket connected on retry');
              _setupSocketListener();
            } else {
              debugPrint('Socket connection failed after retries');
              addUserMessage(
                'Warning: Connection issue detected. You may miss some ride requests.',
              );
            }
          });
        }
      });
    } else {
      debugPrint('Socket already connected when going online');
      _setupSocketListener(); // Ensure listener is active
    }
  }

  void _verifySocketConnectionAfterOnline() {
    // Verify socket connection after successfully going online
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!socketService.isConnected) {
        debugPrint('Warning: Socket disconnected after going online');
        addUserMessage('Connection issue detected. Reconnecting...');
        socketService.connectToSocket();

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (socketService.isConnected) {
            _setupSocketListener();
            addUserMessage('Connection restored successfully');
          }
        });
      } else {
        debugPrint('Socket connection verified after going online');
      }
    });

    // Start connection monitoring when going online
    _startConnectionMonitor();
  }

  void _startConnectionMonitor() {
    _stopConnectionMonitor(); // Stop any existing monitor

    if (currentUiState.isOnline) {
      debugPrint('Starting connection monitor for online driver');
      _connectionMonitorTimer = Timer.periodic(const Duration(seconds: 10), (
        timer,
      ) {
        if (currentUiState.isOnline) {
          if (!socketService.isConnected) {
            debugPrint(
              'Connection monitor: Socket disconnected while online. Reconnecting...',
            );
            socketService.forceReconnect();

            // Setup listener after reconnection
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (socketService.isConnected) {
                _setupSocketListener();
                debugPrint(
                  'Connection monitor: Socket reconnected successfully',
                );
              }
            });
          } else {
            debugPrint('Connection monitor: Socket is healthy');
          }
        } else {
          debugPrint('Connection monitor: Driver is offline, stopping monitor');
          _stopConnectionMonitor();
        }
      });
    }
  }

  void _stopConnectionMonitor() {
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = null;
    debugPrint('Connection monitor stopped');
  }

  void _processRideRequestData(Map<String, dynamic> data) {
    try {
      // Check if all required fields are present
      if (data['_id'] != null &&
          data['pickupLocation'] != null &&
          data['dropoffLocation'] != null) {
        // Create a RideRequestModel from the data
        final RideRequestModel rideRequest = RideRequestModel.fromJson(data);

        // Add to list of ride requests
        final List<RideRequestModel> updatedRides = List.from(
          currentUiState.rideRequests,
        );

        // Check if ride already exists to avoid duplicates
        bool rideExists = false;
        for (var ride in updatedRides) {
          if (ride.id == rideRequest.id) {
            rideExists = true;
            break;
          }
        }

        if (!rideExists) {
          updatedRides.add(rideRequest);
          uiState.value = currentUiState.copyWith(rideRequests: updatedRides);

          appLog(
            'ride service: ${rideRequest.service.isNotEmpty ? rideRequest.service : "No service specified"}',
          );

          debugPrint(
            'Added ride request: ${rideRequest.id} to list. Total requests: ${updatedRides.length}',
          );
        } else {
          debugPrint('Ride request already exists: ${rideRequest.id}');
        }
      } else {
        debugPrint('Missing required fields in ride request data');
      }
    } catch (e) {
      debugPrint('Error processing ride request data: $e');
    }
  }

  Future<void> loadDriverProfile() async {
    try {
      final DriverProfileModel? profile = await LocalStorage.getDriverProfile();
      if (profile != null) {
        uiState.value = currentUiState.copyWith(userName: profile.name ?? '');
        uiState.value = currentUiState.copyWith(
          driverEmail: profile.email ?? '',
        );
      }
    } catch (e) {
      logError('Error loading driver profile: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final result = await getCurrentLocationUsecase.execute();

      result.fold(
        (error) {
          // Error handling
          debugPrint('Location error: $error');
          uiState.value = currentUiState.copyWith(
            userMessage: error.toString(),
          );
        },
        (result) {
          // Success case
          location = result;
          final currentLatLng = LatLng(location!.latitude, location!.longitude);

          // Set a destination that's nearby the current location (about 1-2km away)
          // This adds a small offset to ensure we can get a valid route
          final destinationLatLng = LatLng(
            location!.latitude + 0.01, // Approximately 1km north
            location!.longitude + 0.01, // Approximately 1km east
          );

          uiState.value = currentUiState.copyWith(
            currentLocation: currentLatLng,
            // Update destination and source based on current location
            destinationMapCoordinates: destinationLatLng,
            sourceMapCoordinates: currentLatLng,
          );
          debugPrint('Location updated: ${location.toString()}');
        },
      );
    } catch (e) {
      debugPrint('Exception in getCurrentLocation: $e');
      uiState.value = currentUiState.copyWith(userMessage: e.toString());
    }
  }

  Future<void> _initializeFromArguments() async {
    final dynamic arguments = Get.arguments;
    final bool initialOnlineStatus =
        arguments is Map && arguments.containsKey('isOnline')
            ? arguments['isOnline'] as bool? ?? false
            : false;

    uiState.value = currentUiState.copyWith(isOnline: initialOnlineStatus);
  }

  Future<void> setCustomIcons() async {
    try {
      await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(50, 50)),
        AppAssets.icLocationActive,
      ).then((value) {
        uiState.value = currentUiState.copyWith(sourceIcon: value);
      });
      await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(50, 50)),
        AppAssets.icLocationActive,
      ).then((value) {
        uiState.value = currentUiState.copyWith(destinationIcon: value);
      });
      await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(50, 80)),
        AppAssets.icMyCar,
      ).then((value) {
        uiState.value = currentUiState.copyWith(currentLocationIcon: value);
      });
    } catch (e) {
      logError(e);
    }
  }

  Future<void> setPolyline() async {
    try {
      debugPrint('Setting polyline');
      if (currentUiState.currentLocation == null) {
        debugPrint('Current location is null, cannot set polyline');
        return;
      }

      PolylineResult polylineResult = await currentUiState.polylinePoints
          .getRouteBetweenCoordinates(
            googleApiKey: googleApiKey,
            request: PolylineRequest(
              origin: PointLatLng(
                currentUiState.currentLocation!.latitude,
                currentUiState.currentLocation!.longitude,
              ),
              destination: PointLatLng(
                currentUiState.destinationMapCoordinates.latitude,
                currentUiState.destinationMapCoordinates.longitude,
              ),
              mode: TravelMode.driving,
              optimizeWaypoints: true,
            ),
          );

      if (polylineResult.status == 'REQUEST_DENIED') {
        logError('Google Maps API key error: ${polylineResult.errorMessage}');
        uiState.value = currentUiState.copyWith(
          userMessage: 'Unable to load route. Please check API configuration.',
        );
        return;
      }

      if (polylineResult.status == 'ZERO_RESULTS') {
        debugPrint('No route available between the specified points');
        // Use a straight line instead or update destination to a nearby location
        uiState.value = currentUiState.copyWith(
          polylineCoordinates: [
            currentUiState.currentLocation!,
            currentUiState.destinationMapCoordinates,
          ],
          userMessage: 'No direct route available. Showing approximate path.',
        );
        return;
      }

      if (polylineResult.points.isEmpty) {
        debugPrint('No route points returned from API');
        return;
      }

      uiState.value = currentUiState.copyWith(
        polylineCoordinates:
            polylineResult.points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList(),
      );
      debugPrint(
        'Successfully set polyline with ${polylineResult.points.length} points',
      );
    } catch (e) {
      logError('Error setting polyline: $e');
      uiState.value = currentUiState.copyWith(
        userMessage: 'Unable to load route. Please try again later.',
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> toggleOnlineStatus(bool value) async {
    // Update the UI first for immediate feedback
    uiState.value = currentUiState.copyWith(isOnline: value);

    // If going online, ensure socket connection is established immediately
    if (value) {
      _ensureSocketConnectionForOnlineStatus();
    }

    // Then update the backend
    if (currentUiState.driverEmail?.isNotEmpty == true) {
      toggleLoading(loading: true);

      final params = UpdateStatusParams(
        email: currentUiState.driverEmail!,
        isOnline: value,
      );

      final result = await updateOnlineStatusUseCase.call(params);

      result.fold(
        (error) {
          // Handle error
          addUserMessage('Failed to update online status: $error');
          // Revert UI state if the API call failed
          uiState.value = currentUiState.copyWith(isOnline: !value);
        },
        (_) {
          // Success case
          addUserMessage(value ? 'You are now online' : 'You are now offline');

          // If successfully went online, double-check socket connection and start monitoring
          if (value) {
            _verifySocketConnectionAfterOnline();
          } else {
            // If going offline, stop connection monitoring
            _stopConnectionMonitor();
          }
        },
      );

      toggleLoading(loading: false);
    } else {
      addUserMessage('Cannot update status: Email not available');
    }
  }

  void goOnline() async {
    await toggleOnlineStatus(true);
  }

  // Test method to manually check socket connection (for debugging)
  void testSocketConnection() {
    debugPrint('=== Socket Connection Test ===');
    debugPrint('Socket connected: ${socketService.isConnected}');
    debugPrint('Driver ID: ${LocalStorage.userId}');
    debugPrint('Driver online: ${currentUiState.isOnline}');

    if (!socketService.isConnected) {
      debugPrint('Attempting to connect socket...');
      socketService.connectToSocket();

      Future.delayed(const Duration(milliseconds: 2000), () {
        debugPrint('Socket connected after test: ${socketService.isConnected}');
        if (socketService.isConnected) {
          _setupSocketListener();
          addUserMessage('Socket connection test successful');
        } else {
          addUserMessage('Socket connection test failed');
        }
      });
    } else {
      addUserMessage('Socket is already connected');
    }
  }

  void goToNotifications() {
    Get.to(() => NotificationScreen());
  }

  Future<void> acceptRide(String rideId) async {
    // Find the ride in the list
    debugPrint('Accepting ride: $rideId');
    toggleLoading(loading: true);
    RideRequestModel? rideRequest;
    for (var ride in currentUiState.rideRequests) {
      if (ride.rideId == rideId) {
        rideRequest = ride;
        break;
      }
    }
    if (rideRequest != null) {
      // Add ride details to navigation arguments
      final result = await apiService.patch(ApiEndPoint.ridesAccept + rideId);
      result.fold(
        (error) {
          debugPrint('Error accepting ride: $error');
          addUserMessage('Failed to accept ride: $error');
          CustomToast(message: error.toString());
          toggleLoading(loading: false);
        },
        (success) {
          try {
            // Safely access nested data
            final responseData = success.data;
            if (responseData['data'] != null) {
              final dataSection = responseData['data'];
              final chatData = dataSection['chat'];
              final chatId = chatData?['_id'];
              uiState.value = currentUiState.copyWith(chatId: chatId);
              appLog('chatId: $chatId');
              debugPrint('Ride accepted successfully');
              addUserMessage('Ride accepted successfully');
              final List<RideRequestModel> updatedRides = List.from(
                currentUiState.rideRequests,
              )..removeWhere((ride) => ride.rideId == rideId);
              uiState.value = currentUiState.copyWith(
                rideRequests: updatedRides,
              );
              Get.to(
                () => DriverRidesharePage(
                  rideRequest: rideRequest!,
                  chatId: uiState.value.chatId ?? '',
                ),
              );
              CustomToast(message: 'Ride accepted successfully');
              toggleLoading(loading: false);
            } else {
              debugPrint('No data found in response');
            }
          } catch (e) {
            debugPrint('Error processing ride acceptance response: $e');
            addUserMessage('Ride accepted but failed to process response');
            toggleLoading(loading: false);
          }
        },
      );
    } else {
      debugPrint('Could not find ride with ID: $rideId');
    }
  }

  void declineRide(String rideId) {
    // Remove the ride from the list
    final List<RideRequestModel> updatedRides = List.from(
      currentUiState.rideRequests,
    )..removeWhere((ride) => ride.id == rideId);
    uiState.value = currentUiState.copyWith(rideRequests: updatedRides);
    debugPrint('Removed ride: $rideId from list');
  }

  void handleNotNowPassenger(BuildContext context) {
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  void handleNotNow(BuildContext context) {
    toggleOnlineStatus(false);
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  void setOnlineAndNavigate(BuildContext context) {
    toggleOnlineStatus(true);
    NavigationUtility.fadeReplacement(context, DriverMainPage());
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
  void dispose() {
    _mapController?.dispose();
    _stopConnectionMonitor(); // Stop connection monitoring

    // Remove socket listener when presenter is disposed
    final String driverId = LocalStorage.userId;
    if (driverId.isNotEmpty) {
      socketService.off('notification::$driverId');
      debugPrint('Removed socket listener for notification::$driverId');
    }
    super.dispose();
  }
}
