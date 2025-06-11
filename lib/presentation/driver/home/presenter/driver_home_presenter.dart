import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/constants.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/core/utility/navigation_utility.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/entities/location_entity.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_home_ui_state.dart';
import 'package:cabwire/presentation/driver/home/ui/screens/rideshare_page.dart';
import 'package:cabwire/presentation/driver/main/ui/screens/driver_main_page.dart';
import 'package:cabwire/presentation/driver/notification/ui/screens/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePresenter extends BasePresenter<DriverHomeUiState> {
  final GetCurrentLocationUsecase getCurrentLocationUsecase;
  LocationEntity? location;

  final Obs<DriverHomeUiState> uiState = Obs<DriverHomeUiState>(
    DriverHomeUiState.initial(),
  );

  DriverHomeUiState get currentUiState => uiState.value;
  GoogleMapController? _mapController;

  DriverHomePresenter(this.getCurrentLocationUsecase);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeFromArguments();
    await getCurrentLocation();
    await setPolyline();
    setCustomIcons();
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
          uiState.value = currentUiState.copyWith(
            currentLocation: LatLng(location!.latitude, location!.longitude),
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

  void toggleOnlineStatus(bool value) {
    uiState.value = currentUiState.copyWith(isOnline: value);
  }

  void goOnline() {
    uiState.value = currentUiState.copyWith(isOnline: true);
  }

  void goToNotifications() {
    Get.to(() => NotificationScreen());
  }

  void acceptRide(String rideId) {
    Get.to(() => RidesharePage());
  }

  void declineRide(String rideId) {
    // Remove the ride from the list
    final List<String> updatedRides = List.from(currentUiState.rideRequests)
      ..remove(rideId);
    uiState.value = currentUiState.copyWith(rideRequests: updatedRides);
  }

  void handleNotNowPassenger(BuildContext context) {
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  void handleNotNow(BuildContext context) {
    uiState.value = currentUiState.copyWith(isOnline: false);
    NavigationUtility.fadeReplacement(context, DriverMainPage());
  }

  void setOnlineAndNavigate(BuildContext context) {
    uiState.value = currentUiState.copyWith(isOnline: true);
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
    super.dispose();
  }
}
