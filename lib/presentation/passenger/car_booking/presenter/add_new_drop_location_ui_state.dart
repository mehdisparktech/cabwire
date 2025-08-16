import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewDropLocationSearchHistoryItem {
  final String location;
  final String distance;

  const AddNewDropLocationSearchHistoryItem({
    required this.location,
    required this.distance,
  });
}

class AddNewDropLocationUiState extends BaseUiState {
  final LatLng? currentLocation;
  final LatLng? destinationLocation;
  final String? destinationAddress;

  final List<String> destinationSuggestions;
  final List<AddNewDropLocationSearchHistoryItem> searchHistory;
  final String? routeDistance;
  final String? routeDuration;
  final String? error;
  final LatLng? selectedPickupLocation;
  final String? pickupAddress;

  final List<String> originSuggestions;
  final LatLng? originLocation;
  final String? originAddress;
  final List<LatLng>? routePolylines;
  final ServiceType serviceType;
  final RideResponseModel? rideResponse;
  final String? serviceId;
  const AddNewDropLocationUiState({
    required super.isLoading,
    required super.userMessage,
    this.currentLocation,
    this.destinationLocation,
    this.destinationAddress,
    this.destinationSuggestions = const [],
    this.searchHistory = const [],
    this.routeDistance,
    this.routeDuration,
    this.error,
    this.selectedPickupLocation,
    this.pickupAddress,
    this.originSuggestions = const [],
    this.originLocation,
    this.originAddress,
    this.routePolylines,
    this.serviceType = ServiceType.none,
    this.rideResponse,
    this.serviceId,
  });

  factory AddNewDropLocationUiState.empty() {
    return AddNewDropLocationUiState(
      isLoading: false,
      userMessage: '',
      currentLocation: const LatLng(23.8103, 90.4125), // Default location
      destinationLocation: null,
      destinationAddress: null,
      destinationSuggestions: [],
      searchHistory: [
        AddNewDropLocationSearchHistoryItem(
          location: 'Block B, Banasree, Dhaka.',
          distance: '3.8mi',
        ),
        AddNewDropLocationSearchHistoryItem(
          location: 'Block C, Banasree, Dhaka.',
          distance: '4.2mi',
        ),
        AddNewDropLocationSearchHistoryItem(
          location: 'Gulshan 1, Dhaka.',
          distance: '7.5mi',
        ),
        AddNewDropLocationSearchHistoryItem(
          location: 'Dhanmondi 27, Dhaka.',
          distance: '5.8mi',
        ),
        AddNewDropLocationSearchHistoryItem(
          location: 'Uttara Sector 10, Dhaka.',
          distance: '12.3mi',
        ),
      ],
      routeDistance: null,
      routeDuration: null,
      error: null,
      selectedPickupLocation: null,
      pickupAddress: null,
      originSuggestions: [],
      originLocation: null,
      originAddress: null,
      routePolylines: null,
      serviceType: ServiceType.none,
      rideResponse: null,
      serviceId: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    currentLocation,
    destinationLocation,
    destinationAddress,
    destinationSuggestions,
    searchHistory,
    routeDistance,
    routeDuration,
    error,
    selectedPickupLocation,
    pickupAddress,
    originSuggestions,
    originLocation,
    originAddress,
    routePolylines,
    serviceType,
    rideResponse,
    serviceId,
  ];

  AddNewDropLocationUiState copyWith({
    bool? isLoading,
    String? userMessage,
    LatLng? currentLocation,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<String>? destinationSuggestions,
    List<AddNewDropLocationSearchHistoryItem>? searchHistory,
    String? routeDistance,
    String? routeDuration,
    String? error,
    LatLng? selectedPickupLocation,
    String? pickupAddress,
    List<String>? originSuggestions,
    LatLng? originLocation,
    String? originAddress,
    List<LatLng>? routePolylines,
    ServiceType? serviceType,
    RideResponseModel? rideResponse,
    String? serviceId,
  }) {
    return AddNewDropLocationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentLocation: currentLocation ?? this.currentLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      destinationSuggestions:
          destinationSuggestions ?? this.destinationSuggestions,
      searchHistory: searchHistory ?? this.searchHistory,
      routeDistance: routeDistance ?? this.routeDistance,
      routeDuration: routeDuration ?? this.routeDuration,
      error: error ?? this.error,
      selectedPickupLocation:
          selectedPickupLocation ?? this.selectedPickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      originSuggestions: originSuggestions ?? this.originSuggestions,
      originLocation: originLocation ?? this.originLocation,
      originAddress: originAddress ?? this.originAddress,
      routePolylines: routePolylines ?? this.routePolylines,
      serviceType: serviceType ?? this.serviceType,
      rideResponse: rideResponse ?? this.rideResponse,
      serviceId: serviceId ?? this.serviceId,
    );
  }
}
