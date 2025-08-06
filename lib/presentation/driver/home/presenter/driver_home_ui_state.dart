import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeUiState extends BaseUiState {
  final bool isOnline;
  final String userName;
  final LatLng centerMapCoordinates;
  final LatLng? currentLocation;
  final LatLng destinationMapCoordinates;
  final LatLng sourceMapCoordinates;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  final BitmapDescriptor currentLocationIcon;
  final PolylinePoints polylinePoints;
  final List<LatLng>? polylineCoordinates;
  final List<RideRequestModel> rideRequests;
  final String? driverEmail;
  final String? chatId;
  const DriverHomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.isOnline,
    required this.userName,
    required this.centerMapCoordinates,
    this.currentLocation,
    required this.destinationMapCoordinates,
    required this.sourceMapCoordinates,
    required this.sourceIcon,
    required this.destinationIcon,
    required this.currentLocationIcon,
    required this.polylinePoints,
    this.polylineCoordinates,
    required this.rideRequests,
    this.driverEmail,
    this.chatId,
  });

  // (initial state)
  factory DriverHomeUiState.initial() {
    return DriverHomeUiState(
      isLoading: false,
      userMessage: '',
      isOnline: false,
      userName: '',
      centerMapCoordinates: const LatLng(23.759112, 90.429365),
      currentLocation: null,
      destinationMapCoordinates: const LatLng(23.763766, 90.431407),
      sourceMapCoordinates: const LatLng(23.759112, 90.429365),
      sourceIcon: BitmapDescriptor.defaultMarker,
      destinationIcon: BitmapDescriptor.defaultMarker,
      currentLocationIcon: BitmapDescriptor.defaultMarker,
      polylinePoints: PolylinePoints(),
      polylineCoordinates: null,
      rideRequests: [],
      driverEmail: '',
      chatId: '',
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isOnline,
    userName,
    centerMapCoordinates,
    currentLocation,
    destinationMapCoordinates,
    sourceMapCoordinates,
    sourceIcon,
    destinationIcon,
    currentLocationIcon,
    polylinePoints,
    polylineCoordinates,
    rideRequests,
    driverEmail,
    chatId,
  ];

  DriverHomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isOnline,
    String? userName,
    LatLng? centerMapCoordinates,
    LatLng? currentLocation,
    LatLng? destinationMapCoordinates,
    LatLng? sourceMapCoordinates,
    BitmapDescriptor? sourceIcon,
    BitmapDescriptor? destinationIcon,
    BitmapDescriptor? currentLocationIcon,
    PolylinePoints? polylinePoints,
    List<LatLng>? polylineCoordinates,
    List<RideRequestModel>? rideRequests,
    String? driverEmail,
    String? chatId,
  }) {
    return DriverHomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isOnline: isOnline ?? this.isOnline,
      userName: userName ?? this.userName,
      centerMapCoordinates: centerMapCoordinates ?? this.centerMapCoordinates,
      currentLocation: currentLocation ?? this.currentLocation,
      destinationMapCoordinates:
          destinationMapCoordinates ?? this.destinationMapCoordinates,
      sourceMapCoordinates: sourceMapCoordinates ?? this.sourceMapCoordinates,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      destinationIcon: destinationIcon ?? this.destinationIcon,
      currentLocationIcon: currentLocationIcon ?? this.currentLocationIcon,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      rideRequests: rideRequests ?? this.rideRequests,
      driverEmail: driverEmail ?? this.driverEmail,
      chatId: chatId ?? this.chatId,
    );
  }
}
