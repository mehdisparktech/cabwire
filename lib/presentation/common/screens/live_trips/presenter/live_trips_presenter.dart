import 'dart:async';

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/constants.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/data/models/live_trip_model.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/common/screens/live_trips/presenter/live_trips_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTripsPresenter extends BasePresenter<LiveTripsUiState> {
  final ApiService apiService;

  final Obs<LiveTripsUiState> uiState = Obs<LiveTripsUiState>(
    LiveTripsUiState.initial(),
  );

  LiveTripsUiState get currentUiState => uiState.value;

  LiveTripsPresenter({required this.apiService});

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (uiState.value.rideId != null) {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        getLiveTrips(rideId: uiState.value.rideId!);
      });
    }
  }

  Future<void> init({required String rideId}) async {
    uiState.value = uiState.value.copyWith(rideId: rideId);
    await getLiveTrips(rideId: rideId);
  }

  Future<void> getLiveTrips({required String rideId}) async {
    toggleLoading(loading: true);

    final result = await apiService.get(ApiEndPoint.liveTrips + rideId);
    result.fold(
      (error) => addUserMessage(error.message),
      (data) =>
          uiState.value = uiState.value.copyWith(
            trips:
                RidePathHistoryModel.fromJson(data.data).data?.pathHistory ??
                [],
          ),
    );
    toggleLoading(loading: false);
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    uiState.value = currentUiState.copyWith(mapController: controller);
    setCustomIcons();
    setPolyline();
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

      PolylineResult? polylineResult = await currentUiState.polylinePoints
          ?.getRouteBetweenCoordinates(
            googleApiKey: googleApiKey,
            request: PolylineRequest(
              origin: PointLatLng(
                currentUiState.currentLocation!.latitude,
                currentUiState.currentLocation!.longitude,
              ),
              destination: PointLatLng(
                currentUiState.destinationMapCoordinates!.latitude,
                currentUiState.destinationMapCoordinates!.longitude,
              ),
              mode: TravelMode.driving,
              optimizeWaypoints: true,
            ),
          );

      if (polylineResult?.status == 'REQUEST_DENIED') {
        logError('Google Maps API key error: ${polylineResult?.errorMessage}');
        uiState.value = currentUiState.copyWith(
          userMessage: 'Unable to load route. Please check API configuration.',
        );
        return;
      }

      if (polylineResult?.status == 'ZERO_RESULTS') {
        debugPrint('No route available between the specified points');
        // Use a straight line instead or update destination to a nearby location
        uiState.value = currentUiState.copyWith(
          polylineCoordinates: [
            LatLng(
              currentUiState.currentLocation!.latitude,
              currentUiState.currentLocation!.longitude,
            ),
            LatLng(
              currentUiState.destinationMapCoordinates!.latitude,
              currentUiState.destinationMapCoordinates!.longitude,
            ),
          ],
          userMessage: 'No direct route available. Showing approximate path.',
        );
        return;
      }

      if (polylineResult?.points.isEmpty ?? true) {
        debugPrint('No route points returned from API');
        return;
      }

      uiState.value = currentUiState.copyWith(
        polylineCoordinates:
            polylineResult?.points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList(),
      );
      debugPrint(
        'Successfully set polyline with ${polylineResult?.points.length ?? 0} points',
      );
    } catch (e) {
      logError('Error setting polyline: $e');
      uiState.value = currentUiState.copyWith(
        userMessage: 'Unable to load route. Please try again later.',
      );
    }
  }

  Future<void> toggleOnlineStatus(bool value) async {
    uiState.value = uiState.value.copyWith(isOnline: value);
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = uiState.value.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = uiState.value.copyWith(isLoading: loading);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
