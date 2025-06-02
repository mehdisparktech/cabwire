import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeUiState extends BaseUiState {
  final bool isOnline;
  final String userName;
  final LatLng centerMapCoordinates;
  final LatLng destinationMapCoordinates;
  final LatLng sourceMapCoordinates;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  // Uncomment when ride model is implemented
  // final List<RideRequest> rideRequests;

  const DriverHomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.isOnline,
    required this.userName,
    required this.centerMapCoordinates,
    required this.destinationMapCoordinates,
    required this.sourceMapCoordinates,
    required this.sourceIcon,
    required this.destinationIcon,
    // required this.rideRequests,
  });

  // सुरुवातीची स्थिती (initial state)
  factory DriverHomeUiState.initial() {
    return const DriverHomeUiState(
      isLoading: false,
      userMessage: '',
      isOnline: false,
      userName: "Sabbir",
      centerMapCoordinates: LatLng(23.8103, 90.4125),
      destinationMapCoordinates: LatLng(23.8103, 90.4125),
      sourceMapCoordinates: LatLng(23.8103, 90.4125),
      sourceIcon: BitmapDescriptor.defaultMarker,
      destinationIcon: BitmapDescriptor.defaultMarker,
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
    destinationMapCoordinates,
    sourceMapCoordinates,
    sourceIcon,
    destinationIcon,
    // rideRequests,
  ];

  DriverHomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isOnline,
    String? userName,
    LatLng? centerMapCoordinates,
    LatLng? destinationMapCoordinates,
    LatLng? sourceMapCoordinates,
    BitmapDescriptor? sourceIcon,
    BitmapDescriptor? destinationIcon,
    // List<RideRequest>? rideRequests,
  }) {
    return DriverHomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isOnline: isOnline ?? this.isOnline,
      userName: userName ?? this.userName,
      centerMapCoordinates: centerMapCoordinates ?? this.centerMapCoordinates,
      destinationMapCoordinates:
          destinationMapCoordinates ?? this.destinationMapCoordinates,
      sourceMapCoordinates: sourceMapCoordinates ?? this.sourceMapCoordinates,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      destinationIcon: destinationIcon ?? this.destinationIcon,
      // rideRequests: rideRequests ?? this.rideRequests,
    );
  }
}
