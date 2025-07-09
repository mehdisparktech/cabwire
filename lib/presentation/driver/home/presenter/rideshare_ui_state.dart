import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideshareUiState extends BaseUiState {
  final RideRequestModel? rideRequest;
  final bool isRideStart;
  final bool isRideProcessing;
  final bool isRideEnd;
  final int timerLeft;
  final LatLng? mapCenter;
  final GoogleMapController? mapController;

  const RideshareUiState({
    required super.isLoading,
    required super.userMessage,
    required this.rideRequest,
    required this.isRideStart,
    required this.isRideProcessing,
    required this.isRideEnd,
    required this.timerLeft,
    required this.mapCenter,
    this.mapController,
  });

  factory RideshareUiState.initial() {
    return RideshareUiState(
      isLoading: false,
      userMessage: null,
      rideRequest: null,
      isRideStart: false,
      isRideProcessing: false,
      isRideEnd: false,
      timerLeft: 5,
      mapCenter: null,
      mapController: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    rideRequest,
    isRideStart,
    isRideProcessing,
    isRideEnd,
    timerLeft,
    mapCenter,
    mapController,
  ];

  RideshareUiState copyWith({
    bool? isLoading,
    String? userMessage,
    RideRequestModel? rideRequest,
    bool? isRideStart,
    bool? isRideProcessing,
    bool? isRideEnd,
    int? timerLeft,
    LatLng? mapCenter,
    GoogleMapController? mapController,
  }) {
    return RideshareUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      rideRequest: rideRequest ?? this.rideRequest,
      isRideStart: isRideStart ?? this.isRideStart,
      isRideProcessing: isRideProcessing ?? this.isRideProcessing,
      isRideEnd: isRideEnd ?? this.isRideEnd,
      timerLeft: timerLeft ?? this.timerLeft,
      mapCenter: mapCenter ?? this.mapCenter,
      mapController: mapController ?? this.mapController,
    );
  }
}
