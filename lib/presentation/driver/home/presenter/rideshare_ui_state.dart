import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideshareUiState extends BaseUiState {
  final RideRequestModel? rideRequest;
  final bool isRideStart;
  final bool isRideProcessing;
  final bool isRideEnd;
  final int timerLeft;
  final int estimatedTimeInSeconds;
  final LatLng? mapCenter;
  final GoogleMapController? mapController;
  final Set<Marker> markers;
  final LatLng? driverLocation;
  final LatLng? currentUserLocation;
  final double userHeading;
  final double? currentSpeed;
  final List<LatLng>? polylineCoordinates;
  final LatLng sourceMapCoordinates;
  final LatLng destinationMapCoordinates;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  final BitmapDescriptor driverIcon;
  final BitmapDescriptor userLocationIcon;
  final String chatId;
  final String socketEventName;

  const RideshareUiState({
    required super.isLoading,
    required super.userMessage,
    required this.rideRequest,
    required this.isRideStart,
    required this.isRideProcessing,
    required this.isRideEnd,
    required this.timerLeft,
    required this.estimatedTimeInSeconds,
    required this.mapCenter,
    this.mapController,
    required this.markers,
    this.driverLocation,
    this.currentUserLocation,
    this.userHeading = 0.0,
    this.currentSpeed,
    this.polylineCoordinates,
    required this.sourceMapCoordinates,
    required this.destinationMapCoordinates,
    required this.sourceIcon,
    required this.destinationIcon,
    required this.driverIcon,
    required this.userLocationIcon,
    required this.chatId,
    required this.socketEventName,
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
      estimatedTimeInSeconds: 5 * 60,
      mapCenter: null,
      mapController: null,
      markers: {},
      driverLocation: null,
      currentUserLocation: null,
      userHeading: 0.0,
      currentSpeed: null,
      polylineCoordinates: null,
      // Default location in Dhaka
      sourceMapCoordinates: const LatLng(23.759112, 90.429365),
      destinationMapCoordinates: const LatLng(23.763766, 90.431407),
      sourceIcon: BitmapDescriptor.defaultMarker,
      destinationIcon: BitmapDescriptor.defaultMarker,
      driverIcon: BitmapDescriptor.defaultMarker,
      userLocationIcon: BitmapDescriptor.defaultMarker,
      chatId: '',
      socketEventName: '',
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
    estimatedTimeInSeconds,
    mapCenter,
    mapController,
    markers,
    driverLocation,
    currentUserLocation,
    userHeading,
    currentSpeed,
    polylineCoordinates,
    sourceMapCoordinates,
    destinationMapCoordinates,
    sourceIcon,
    destinationIcon,
    driverIcon,
    userLocationIcon,
    chatId,
    socketEventName,
  ];

  RideshareUiState copyWith({
    bool? isLoading,
    String? userMessage,
    RideRequestModel? rideRequest,
    bool? isRideStart,
    bool? isRideProcessing,
    bool? isRideEnd,
    int? timerLeft,
    int? estimatedTimeInSeconds,
    LatLng? mapCenter,
    GoogleMapController? mapController,
    Set<Marker>? markers,
    LatLng? driverLocation,
    LatLng? currentUserLocation,
    double? userHeading,
    double? currentSpeed,
    List<LatLng>? polylineCoordinates,
    LatLng? sourceMapCoordinates,
    LatLng? destinationMapCoordinates,
    BitmapDescriptor? sourceIcon,
    BitmapDescriptor? destinationIcon,
    BitmapDescriptor? driverIcon,
    BitmapDescriptor? userLocationIcon,
    String? chatId,
    String? socketEventName,
  }) {
    return RideshareUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      rideRequest: rideRequest ?? this.rideRequest,
      isRideStart: isRideStart ?? this.isRideStart,
      isRideProcessing: isRideProcessing ?? this.isRideProcessing,
      isRideEnd: isRideEnd ?? this.isRideEnd,
      timerLeft: timerLeft ?? this.timerLeft,
      estimatedTimeInSeconds:
          estimatedTimeInSeconds ?? this.estimatedTimeInSeconds,
      mapCenter: mapCenter ?? this.mapCenter,
      mapController: mapController ?? this.mapController,
      markers: markers ?? this.markers,
      driverLocation: driverLocation ?? this.driverLocation,
      currentUserLocation: currentUserLocation ?? this.currentUserLocation,
      userHeading: userHeading ?? this.userHeading,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      sourceMapCoordinates: sourceMapCoordinates ?? this.sourceMapCoordinates,
      destinationMapCoordinates:
          destinationMapCoordinates ?? this.destinationMapCoordinates,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      destinationIcon: destinationIcon ?? this.destinationIcon,
      driverIcon: driverIcon ?? this.driverIcon,
      userLocationIcon: userLocationIcon ?? this.userLocationIcon,
      chatId: chatId ?? this.chatId,
      socketEventName: socketEventName ?? this.socketEventName,
    );
  }
}
