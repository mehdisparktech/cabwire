import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideShareUiState extends BaseUiState {
  final bool isRideStart;
  final bool isRideStartOtp;
  final bool isRideProcessing;
  final bool isRideEnd;
  final int timerLeft;
  final int estimatedTimeInSeconds; // Added property to track time in seconds
  final Set<Marker> markers;
  final GoogleMapController? mapController;
  final RideResponseModel? rideResponse;
  final String rideId;
  final LatLng? driverLocation;
  final LatLng? currentUserLocation;
  final double userHeading;
  final double? currentSpeed; // Current speed in m/s from GPS
  final List<LatLng>? polylineCoordinates;
  final LatLng sourceMapCoordinates;
  final LatLng destinationMapCoordinates;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  final BitmapDescriptor driverIcon;
  final BitmapDescriptor userLocationIcon;
  final String chatId;
  final String socketEventName;

  const RideShareUiState({
    required super.isLoading,
    required super.userMessage,
    required this.isRideStart,
    required this.isRideStartOtp,
    required this.isRideProcessing,
    required this.isRideEnd,
    required this.timerLeft,
    required this.estimatedTimeInSeconds, // Added parameter
    required this.markers,
    this.mapController,
    required this.rideResponse,
    required this.rideId,
    this.driverLocation,
    this.currentUserLocation,
    this.userHeading = 0.0,
    this.currentSpeed, // Current speed parameter
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

  factory RideShareUiState.empty({
    required String rideId,
    required RideResponseModel? rideResponse,
  }) {
    return RideShareUiState(
      isLoading: false,
      userMessage: null,
      isRideStart: false,
      isRideStartOtp: false,
      isRideProcessing: false,
      isRideEnd: false,
      timerLeft: 5,
      estimatedTimeInSeconds: 5 * 60, // Initialize with 5 minutes in seconds
      markers: {},
      mapController: null,
      rideResponse: rideResponse,
      rideId: rideId,
      driverLocation: null,
      currentUserLocation: null,
      userHeading: 0.0,
      currentSpeed: null, // Initialize with no speed
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
    isRideStart,
    isRideStartOtp,
    isRideProcessing,
    isRideEnd,
    timerLeft,
    estimatedTimeInSeconds,
    markers,
    mapController,
    rideResponse,
    rideId,
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

  RideShareUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isRideStart,
    bool? isRideStartOtp,
    bool? isRideProcessing,
    bool? isRideEnd,
    int? timerLeft,
    int? estimatedTimeInSeconds,
    Set<Marker>? markers,
    GoogleMapController? mapController,
    RideResponseModel? rideResponse,
    String? rideId,
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
    return RideShareUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isRideStart: isRideStart ?? this.isRideStart,
      isRideStartOtp: isRideStartOtp ?? this.isRideStartOtp,
      isRideProcessing: isRideProcessing ?? this.isRideProcessing,
      isRideEnd: isRideEnd ?? this.isRideEnd,
      timerLeft: timerLeft ?? this.timerLeft,
      estimatedTimeInSeconds:
          estimatedTimeInSeconds ?? this.estimatedTimeInSeconds,
      markers: markers ?? this.markers,
      mapController: mapController ?? this.mapController,
      rideResponse: rideResponse ?? this.rideResponse,
      rideId: rideId ?? this.rideId,
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
