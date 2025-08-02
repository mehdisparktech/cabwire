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
import 'package:cabwire/domain/usecases/submit_review_usecase.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/car_booking_details_screen.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_close_otp_page.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_trip_start_otp_page.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/payment_method_screen.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/sucessfull_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ride_share_ui_state.dart';

class RideSharePresenter extends BasePresenter<RideShareUiState> {
  // Constants
  static const double _defaultPickupSpeedKmh = 25.0;
  static const double _defaultRideSpeedKmh = 30.0;
  static const double _earthRadiusMeters = 6371000;
  static const Duration _reconnectInterval = Duration(seconds: 5);
  static const Duration _timeUpdateInterval = Duration(seconds: 30);
  static const Duration _socketSetupDelay = Duration(milliseconds: 500);

  // Services
  final ApiService _apiService = locate<ApiService>();
  final SocketService _socketService = locate<SocketService>();
  final GetCurrentLocationUsecase _getCurrentLocationUsecase =
      locate<GetCurrentLocationUsecase>();
  final GetLocationUpdatesUsecase _getLocationUpdatesUsecase =
      locate<GetLocationUpdatesUsecase>();
  final SubmitReviewUseCase submitReviewUseCase;
  final PolylinePoints _polylinePoints = PolylinePoints();

  // Timers and Subscriptions
  Timer? _reconnectTimer;
  Timer? _timeUpdateTimer;
  StreamSubscription? _locationSubscription;

  // UI State
  final Obs<RideShareUiState> uiState;
  RideShareUiState get currentUiState => uiState.value;

  // Controllers
  final TextEditingController commentController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  WebViewController? webViewController;

  RideSharePresenter({
    String rideId = '',
    rideResponse,
    required this.submitReviewUseCase,
  }) : uiState = Obs<RideShareUiState>(
         RideShareUiState.empty(rideId: rideId, rideResponse: rideResponse),
       ) {
    if (rideId.isNotEmpty && rideResponse != null) {
      _initialize();
    }
  }

  // ===== Lifecycle Methods =====

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }

  void init({
    required String rideId,
    required rideResponse,
    required String chatId,
    required bool isRideProcessing,
  }) {
    appLog(
      "Initializing RideSharePresenter with isRideProcessing: $isRideProcessing",
    );
    uiState.value = RideShareUiState.empty(
      rideId: rideId,
      rideResponse: rideResponse,
    );
    uiState.value = currentUiState.copyWith(
      isRideProcessing: isRideProcessing,
      chatId: chatId,
    );
    appLog(
      "After setting, isRideProcessing value: ${currentUiState.isRideProcessing}",
    );
    _initialize();
  }

  // ===== Private Initialization Methods =====

  void _initialize() {
    uiState.value = currentUiState.copyWith(
      socketEventName:
          'notification::${currentUiState.rideResponse?.data.userId}',
    );
    appLog("Ride Processing in init: ${currentUiState.isRideProcessing}");
    _ensureSocketConnection();
    _setCustomIcons();
    _initializeLocations();
    _getCurrentUserLocation();
    _startLocationUpdates();
    _startTimeUpdates();
    _startReconnectMonitor();

    // Delay socket setup to ensure connection
    Future.delayed(_socketSetupDelay, _setupSocketListeners);
  }

  void _cleanup() {
    _locationSubscription?.cancel();
    _reconnectTimer?.cancel();
    _timeUpdateTimer?.cancel();

    if (currentUiState.rideId.isNotEmpty) {
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
      userHeading: heading,
      currentSpeed: location.speed,
    );

    appLog(
      "Current speed: ${location.speed?.toStringAsFixed(2) ?? 'unavailable'} m/s",
    );

    _updateEstimatedTimeRemaining();
    _setMapMarkers();
  }

  void _initializeLocations() {
    if (currentUiState.rideResponse == null) return;

    try {
      final pickupLocation = currentUiState.rideResponse!.data.pickupLocation;
      final dropoffLocation = currentUiState.rideResponse!.data.dropoffLocation;

      final pickupLatLng = LatLng(pickupLocation.lat, pickupLocation.lng);
      final dropoffLatLng = LatLng(dropoffLocation.lat, dropoffLocation.lng);

      final estimatedTime = _calculateInitialEstimatedTime(
        pickupLatLng,
        dropoffLatLng,
      );

      uiState.value = currentUiState.copyWith(
        sourceMapCoordinates: pickupLatLng,
        destinationMapCoordinates: dropoffLatLng,
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
    appLog("Current location: ${currentUiState.currentUserLocation}");

    final targetInfo = _getTargetLocationInfo();
    if (targetInfo == null) return;

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
    if (currentUiState.isRideStart) {
      return (
        location: currentUiState.sourceMapCoordinates,
        averageSpeed: _getSpeed(_defaultPickupSpeedKmh),
      );
    } else if (currentUiState.isRideProcessing) {
      return (
        location: currentUiState.destinationMapCoordinates,
        averageSpeed: _getSpeed(_defaultRideSpeedKmh),
      );
    }
    return null;
  }

  double _getSpeed(double defaultSpeedKmh) {
    if (currentUiState.currentSpeed != null &&
        currentUiState.currentSpeed! > 0) {
      appLog(
        "Using real-time speed: ${currentUiState.currentSpeed!.toStringAsFixed(2)} m/s",
      );
      return currentUiState.currentSpeed!;
    }
    final speedMps = defaultSpeedKmh / 3.6;
    appLog("Using default speed: ${speedMps.toStringAsFixed(2)} m/s");
    return speedMps;
  }

  Duration _calculateEstimatedTime(double distanceMeters, double speedMps) {
    final seconds = (distanceMeters / speedMps).round();
    appLog(
      "Distance: ${distanceMeters.toStringAsFixed(0)}m, Time: ${(seconds / 60).ceil()} minutes",
    );
    return Duration(seconds: seconds);
  }

  Duration _calculateInitialEstimatedTime(LatLng pickup, LatLng dropoff) {
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
    final markers = <Marker>{
      _createMarker(
        id: 'pickup',
        position: currentUiState.sourceMapCoordinates,
        icon: currentUiState.sourceIcon,
        title: 'Pickup Location',
        snippet: currentUiState.rideResponse?.data.pickupLocation.address ?? '',
      ),
      _createMarker(
        id: 'dropoff',
        position: currentUiState.destinationMapCoordinates,
        icon: currentUiState.destinationIcon,
        title: 'Dropoff Location',
        snippet:
            currentUiState.rideResponse?.data.dropoffLocation.address ?? '',
      ),
    };

    if (currentUiState.driverLocation != null) {
      markers.add(
        _createMarker(
          id: 'driver',
          position: currentUiState.driverLocation!,
          icon: currentUiState.driverIcon,
          title: 'Driver Location',
        ),
      );
    }

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

  void onMapCreated(GoogleMapController controller) {
    uiState.value = currentUiState.copyWith(mapController: controller);
    _fitMapToBounds();
  }

  void _fitMapToBounds() {
    if (currentUiState.mapController == null) return;

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
    if (currentUiState.rideId.isEmpty) return;

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
      // Handle ride acceptance with chat
      if (_isRideAcceptance(data)) {
        _extractChatId(data);
      }

      // Handle ride events
      if (data['rideProgress'] == true) {
        _handleRideProcessing(data);
      } else if (data['rideStartOtp'] == true) {
        appLog("rideStartOtp:=======<><><>< $data");
        appLog("rideStartOtp:=======<><><>< ${data['otp']}");
        final otp = data['otp'] != null ? data['otp'].toString() : "";
        _handleRideStartOtp(data, otp);
      } else if (data['rideStart'] == true) {
        _handleRideStart(data);
      } else if (data['rideEnd'] == true) {
        _handleRideEnd(data);
      } else if (_isDriverLocationUpdate(data)) {
        _handleDriverLocationUpdate(data);
      }

      // Handle messages
      _handleMessageIfPresent(data);
    } catch (e) {
      appLog("Error processing notification: $e");
    }
  }

  bool _isRideAcceptance(Map<String, dynamic> data) {
    return data['rideAccept'] == true && data.containsKey('chat');
  }

  bool _isDriverLocationUpdate(Map<String, dynamic> data) {
    return data.containsKey('lat') && data.containsKey('lng');
  }

  void _extractChatId(Map<String, dynamic> data) {
    if (data['chat'] is Map<String, dynamic> && data['chat']['_id'] != null) {
      final chatId = data['chat']['_id'].toString();
      appLog("Chat ID extracted: $chatId");
      uiState.value = currentUiState.copyWith(chatId: chatId);
    }
  }

  void _handleMessageIfPresent(Map<String, dynamic> data) {
    final message = data['text'] ?? data['message'];
    if (message != null) {
      showMessage(message: message.toString());
    }
  }

  void _handleRideStartOtp(Map<String, dynamic> data, String otp) {
    appLog("Ride start otp event received");
    appLog("Ride start otp event received:************ $otp");
    //uiState.value = currentUiState.copyWith(isRideStartOtp: true);

    Get.offAll(
      () => PassengerTripStartOtpPage(
        otp: otp,
        chatId: currentUiState.chatId,
        rideId: currentUiState.rideId,
        rideResponse: currentUiState.rideResponse!,
      ),
    );

    showMessage(
      message: data['text'] ?? data['message'] ?? 'Your ride has started!',
    );
  }

  void _handleRideStart(Map<String, dynamic> data) {
    appLog("Ride start event received");
    uiState.value = currentUiState.copyWith(isRideStart: true);

    if (currentUiState.driverLocation != null) {
      _updateTimeToPickup();
    }

    showMessage(
      message: data['text'] ?? data['message'] ?? 'Your ride has started!',
    );
  }

  void _handleRideProcessing(Map<String, dynamic> data) {
    appLog("Ride processing event received");
    uiState.value = currentUiState.copyWith(
      isRideProcessing: true,
      isRideStart: false,
    );

    if (currentUiState.driverLocation != null) {
      _updateEstimatedTimeRemaining();
    }

    showMessage(
      message: data['text'] ?? data['message'] ?? 'Your ride is in progress',
    );
  }

  void _handleRideEnd(Map<String, dynamic> data) {
    appLog("Ride end event received");
    uiState.value = currentUiState.copyWith(
      isRideProcessing: false,
      isRideEnd: true,
    );

    showMessage(message: data['message'] ?? 'Your ride has ended!');

    if (data['rideComplete'] == true) {
      _navigateToDetails();
    }
  }

  void _handleDriverLocationUpdate(Map<String, dynamic> data) {
    final driverLocation = LatLng(data['lat'] as double, data['lng'] as double);

    uiState.value = currentUiState.copyWith(driverLocation: driverLocation);
    _setMapMarkers();
    _updateEstimatedTimeRemaining();

    currentUiState.mapController?.animateCamera(
      CameraUpdate.newLatLng(driverLocation),
    );
  }

  void _updateTimeToPickup() {
    final distance = _calculateDistance(
      currentUiState.driverLocation!,
      currentUiState.sourceMapCoordinates,
    );
    final time = _calculateEstimatedTime(
      distance,
      _defaultPickupSpeedKmh / 3.6,
    );

    uiState.value = currentUiState.copyWith(
      timerLeft: time.inMinutes,
      estimatedTimeInSeconds: time.inSeconds,
    );
  }

  // ===== Navigation Methods =====

  void _navigateToDetails() {
    Get.offAll(
      () => CarBookingDetailsScreen(rideResponse: currentUiState.rideResponse!),
    );
  }

  Future<void> onForwardPressed(BuildContext context) async {
    if (currentUiState.isRideEnd) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CarBookingDetailsScreen(
                rideResponse: currentUiState.rideResponse!,
              ),
        ),
      );
    } else {
      _setupNavigationListener();
    }
  }

  void _setupNavigationListener() {
    _socketService.on(currentUiState.socketEventName, (data) {
      if (data is Map<String, dynamic> && data['rideComplete'] == true) {
        _navigateToDetails();
      }
    });
  }

  // ===== API Methods =====

  Future<void> requestCloseRide() async {
    toggleLoading(loading: true);

    final result = await _apiService.patch(
      ApiEndPoint.requestCloseRide +
          (currentUiState.rideResponse?.data.id ?? ''),
    );

    toggleLoading(loading: false);

    result.fold((error) => CustomToast(message: error.message), (success) {
      CustomToast(message: success.message ?? '');
      final otp = success.data['data']['otp'].toString();
      Get.to(() => PassengerTripCloseOtpPage(otp: otp));
    });
  }

  void handleTripClosureButtonPress() {
    requestCloseRide();
    if (!currentUiState.isRideEnd) {
      uiState.value = currentUiState.copyWith(isRideProcessing: true);
    }
  }

  Future<void> submitFeedback() async {
    toggleLoading(loading: true);

    try {
      final result = await submitReviewUseCase.execute(
        SubmitReviewParams(
          serviceType: 'Cabwire',
          serviceId: currentUiState.rideResponse?.data.id ?? '',
          comment: commentController.text,
          rating: 4,
        ),
      );

      result.fold(
        (error) {
          CustomToast(message: error);
          Get.offAll(() => SucessfullScreen());
        },
        (success) {
          CustomToast(message: success);
          Get.offAll(() => SucessfullScreen());
        },
      );
    } catch (e) {
      CustomToast(message: e.toString());
    } finally {
      toggleLoading(loading: false);
    }
  }

  Future<void> payNow(String rideId, BuildContext context) async {
    toggleLoading(loading: true);

    try {
      final result = await _apiService.post(
        ApiEndPoint.payRide,
        body: {"rideId": rideId},
      );

      result.fold((error) => CustomToast(message: error.message), (success) {
        CustomToast(message: success.message ?? '');
        final redirectUrl = success.data['data']['redirectUrl'];
        _initializePayment(redirectUrl, context);
      });
    } catch (e) {
      CustomToast(message: e.toString());
    } finally {
      toggleLoading(loading: false);
    }
  }

  void _initializePayment(String paymentUrl, BuildContext context) {
    if (paymentUrl.isEmpty) return;

    Get.to(() => PaymentMethodScreen());

    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) => toggleLoading(loading: true),
              onPageFinished: (url) {
                toggleLoading(loading: false);
                _handlePaymentResult(url);
              },
            ),
          )
          ..loadRequest(Uri.parse(paymentUrl));
  }

  void _handlePaymentResult(String url) {
    if (url.contains("success")) {
      Get.offAll(() => SucessfullScreen());
    } else if (url.contains("failed") || url.contains("cancel")) {
      Get.back();
    }
  }

  // ===== BasePresenter Implementation =====

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
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
