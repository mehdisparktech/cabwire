import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/live_trip_entity.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTripsUiState extends BaseUiState {
  final List<PathHistoryEntity>? trips;
  final PointLatLng? sourceMapCoordinates;
  final PointLatLng? destinationMapCoordinates;
  final PointLatLng? currentLocation;
  final BitmapDescriptor? sourceIcon;
  final BitmapDescriptor? destinationIcon;
  final BitmapDescriptor? currentLocationIcon;
  final List<LatLng>? polylineCoordinates;
  final bool isOnline;
  final PolylinePoints? polylinePoints;
  final GoogleMapController? mapController;
  final LatLng? centerMapCoordinates;
  final String? rideId;

  const LiveTripsUiState({
    required super.isLoading,
    required super.userMessage,
    this.trips,
    this.sourceMapCoordinates,
    this.destinationMapCoordinates,
    this.currentLocation,
    this.sourceIcon,
    this.destinationIcon,
    this.currentLocationIcon,
    this.polylineCoordinates,
    required this.isOnline,
    this.polylinePoints,
    this.mapController,
    this.centerMapCoordinates,
    this.rideId,
  });

  @override
  List<Object?> get props => [trips, isLoading, userMessage];

  factory LiveTripsUiState.initial() {
    return LiveTripsUiState(
      isLoading: false,
      userMessage: '',
      trips: null,
      sourceMapCoordinates: PointLatLng(0, 0),
      destinationMapCoordinates: PointLatLng(0, 0),
      currentLocation: PointLatLng(0, 0),
      sourceIcon: BitmapDescriptor.defaultMarker,
      destinationIcon: BitmapDescriptor.defaultMarker,
      currentLocationIcon: BitmapDescriptor.defaultMarker,
      polylineCoordinates: null,
      isOnline: false,
      polylinePoints: null,
      mapController: null,
      centerMapCoordinates: null,
      rideId: null,
    );
  }

  LiveTripsUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<PathHistoryEntity>? trips,
    PointLatLng? sourceMapCoordinates,
    PointLatLng? destinationMapCoordinates,
    PointLatLng? currentLocation,
    BitmapDescriptor? sourceIcon,
    BitmapDescriptor? destinationIcon,
    BitmapDescriptor? currentLocationIcon,
    List<LatLng>? polylineCoordinates,
    bool? isOnline,
    PolylinePoints? polylinePoints,
    GoogleMapController? mapController,
    LatLng? centerMapCoordinates,
    String? rideId,
  }) {
    return LiveTripsUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      trips: trips ?? this.trips,
      sourceMapCoordinates: sourceMapCoordinates ?? this.sourceMapCoordinates,
      destinationMapCoordinates:
          destinationMapCoordinates ?? this.destinationMapCoordinates,
      currentLocation: currentLocation ?? this.currentLocation,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      destinationIcon: destinationIcon ?? this.destinationIcon,
      currentLocationIcon: currentLocationIcon ?? this.currentLocationIcon,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      isOnline: isOnline ?? this.isOnline,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      mapController: mapController ?? this.mapController,
      centerMapCoordinates: centerMapCoordinates ?? this.centerMapCoordinates,
      rideId: rideId ?? this.rideId,
    );
  }
}
