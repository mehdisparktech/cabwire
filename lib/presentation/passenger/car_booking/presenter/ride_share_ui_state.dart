import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideShareUiState extends BaseUiState {
  final bool isRideStart;
  final bool isRideProcessing;
  final bool isRideEnd;
  final int timerLeft;
  final Set<Marker> markers;
  final GoogleMapController? mapController;
  final RideResponseModel? rideResponse;
  final String rideId;

  const RideShareUiState({
    required super.isLoading,
    required super.userMessage,
    required this.isRideStart,
    required this.isRideProcessing,
    required this.isRideEnd,
    required this.timerLeft,
    required this.markers,
    this.mapController,
    required this.rideResponse,
    required this.rideId,
  });

  factory RideShareUiState.empty({
    required String rideId,
    required RideResponseModel? rideResponse,
  }) {
    return RideShareUiState(
      isLoading: false,
      userMessage: null,
      isRideStart: false,
      isRideProcessing: false,
      isRideEnd: false,
      timerLeft: 5,
      markers: {},
      mapController: null,
      rideResponse: rideResponse,
      rideId: rideId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isRideStart,
    isRideProcessing,
    isRideEnd,
    timerLeft,
    markers,
    mapController,
    rideResponse,
    rideId,
  ];

  RideShareUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isRideStart,
    bool? isRideProcessing,
    bool? isRideEnd,
    int? timerLeft,
    Set<Marker>? markers,
    GoogleMapController? mapController,
    RideResponseModel? rideResponse,
    String? rideId,
  }) {
    return RideShareUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isRideStart: isRideStart ?? this.isRideStart,
      isRideProcessing: isRideProcessing ?? this.isRideProcessing,
      isRideEnd: isRideEnd ?? this.isRideEnd,
      timerLeft: timerLeft ?? this.timerLeft,
      markers: markers ?? this.markers,
      mapController: mapController ?? this.mapController,
      rideResponse: rideResponse ?? this.rideResponse,
      rideId: rideId ?? this.rideId,
    );
  }
}
