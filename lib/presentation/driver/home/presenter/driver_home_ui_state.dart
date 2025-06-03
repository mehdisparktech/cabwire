import 'package:cabwire/core/base/base_ui_state.dart';
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
  // Uncomment when ride model is implemented
  // final List<RideRequest> rideRequests;

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
    // required this.rideRequests,
  });

  // सुरुवातीची स्थिती (initial state)
  factory DriverHomeUiState.initial() {
    return const DriverHomeUiState(
      isLoading: false,
      userMessage: '',
      isOnline: false,
      userName: "Sabbir",
      centerMapCoordinates: LatLng(23.759112, 90.429365),
      currentLocation: null,
      destinationMapCoordinates: LatLng(23.763766, 90.431407),
      sourceMapCoordinates: LatLng(23.759112, 90.429365),
      sourceIcon: BitmapDescriptor.defaultMarker,
      destinationIcon: BitmapDescriptor.defaultMarker,
      currentLocationIcon: BitmapDescriptor.defaultMarker,
      // rideRequests: [],
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
    // rideRequests,
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
    // List<RideRequest>? rideRequests,
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
      // rideRequests: rideRequests ?? this.rideRequests,
    );
  }
}
