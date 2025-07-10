import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindingRidesUiState extends BaseUiState {
  final String? error;
  final bool isRideAccepted;
  final bool isRideStarted;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final String? driverVehicle;
  final LatLng? driverLocation;
  final GoogleMapController? mapController;

  const FindingRidesUiState({
    super.isLoading = false,
    super.userMessage,
    this.error,
    required this.isRideAccepted,
    required this.isRideStarted,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.driverVehicle,
    this.driverLocation,
    this.mapController,
  });

  factory FindingRidesUiState.initial() {
    return FindingRidesUiState(
      isLoading: false,
      isRideAccepted: false,
      isRideStarted: false,
    );
  }

  FindingRidesUiState copyWith({
    bool? isLoading,
    String? error,
    String? userMessage,
    bool? isRideAccepted,
    bool? isRideStarted,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? driverPhoto,
    String? driverVehicle,
    LatLng? driverLocation,
    GoogleMapController? mapController,
  }) {
    return FindingRidesUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userMessage: userMessage ?? this.userMessage,
      isRideAccepted: isRideAccepted ?? this.isRideAccepted,
      isRideStarted: isRideStarted ?? this.isRideStarted,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverPhoto: driverPhoto ?? this.driverPhoto,
      driverVehicle: driverVehicle ?? this.driverVehicle,
      driverLocation: driverLocation ?? this.driverLocation,
      mapController: mapController ?? this.mapController,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    userMessage,
    isRideAccepted,
    isRideStarted,
    driverId,
    driverName,
    driverPhone,
    driverPhoto,
    driverVehicle,
    driverLocation,
    mapController,
  ];
}
