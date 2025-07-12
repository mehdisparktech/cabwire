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
  final LatLng? driverLocation;
  final List<LatLng>? polylineCoordinates;
  final LatLng sourceMapCoordinates;
  final LatLng destinationMapCoordinates;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  final BitmapDescriptor driverIcon;

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
    this.driverLocation,
    this.polylineCoordinates,
    required this.sourceMapCoordinates,
    required this.destinationMapCoordinates,
    required this.sourceIcon,
    required this.destinationIcon,
    required this.driverIcon,
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
      driverLocation: null,
      polylineCoordinates: null,
      // Default location in Dhaka
      sourceMapCoordinates: const LatLng(23.759112, 90.429365),
      destinationMapCoordinates: const LatLng(23.763766, 90.431407),
      sourceIcon: BitmapDescriptor.defaultMarker,
      destinationIcon: BitmapDescriptor.defaultMarker,
      driverIcon: BitmapDescriptor.defaultMarker,
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
    driverLocation,
    polylineCoordinates,
    sourceMapCoordinates,
    destinationMapCoordinates,
    sourceIcon,
    destinationIcon,
    driverIcon,
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
    LatLng? driverLocation,
    List<LatLng>? polylineCoordinates,
    LatLng? sourceMapCoordinates,
    LatLng? destinationMapCoordinates,
    BitmapDescriptor? sourceIcon,
    BitmapDescriptor? destinationIcon,
    BitmapDescriptor? driverIcon,
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
      driverLocation: driverLocation ?? this.driverLocation,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      sourceMapCoordinates: sourceMapCoordinates ?? this.sourceMapCoordinates,
      destinationMapCoordinates:
          destinationMapCoordinates ?? this.destinationMapCoordinates,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      destinationIcon: destinationIcon ?? this.destinationIcon,
      driverIcon: driverIcon ?? this.driverIcon,
    );
  }
}
