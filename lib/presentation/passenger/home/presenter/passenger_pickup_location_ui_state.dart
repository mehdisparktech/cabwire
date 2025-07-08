import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerPickupLocationUiState extends BaseUiState {
  final LatLng? currentLocation;
  final LatLng? selectedPickupLocation;
  final String? pickupAddress;
  final GoogleMapController? mapController;
  final bool isCameraMoving;
  final TextEditingController searchController;
  final TextEditingController destinationController;
  final TextEditingController fromController;
  final List<String> searchSuggestions;
  final String? error;
  final List<String> originSuggestions;

  const PassengerPickupLocationUiState({
    required super.isLoading,
    required super.userMessage,
    this.currentLocation,
    this.selectedPickupLocation,
    this.pickupAddress,
    this.mapController,
    this.isCameraMoving = false,
    required this.searchController,
    required this.destinationController,
    required this.fromController,
    this.searchSuggestions = const [],
    this.error,
    this.originSuggestions = const [],
  });

  factory PassengerPickupLocationUiState.empty() {
    return PassengerPickupLocationUiState(
      isLoading: false,
      userMessage: '',
      currentLocation: const LatLng(
        23.8103,
        90.4125,
      ), // Default location (Dhaka)
      selectedPickupLocation: null,
      pickupAddress: null,
      mapController: null,
      isCameraMoving: false,
      searchController: TextEditingController(),
      destinationController: TextEditingController(),
      fromController: TextEditingController(),
      searchSuggestions: [],
      originSuggestions: [],
      error: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    currentLocation,
    selectedPickupLocation,
    pickupAddress,
    mapController,
    isCameraMoving,
    searchController,
    destinationController,
    fromController,
    searchSuggestions,
    originSuggestions,
    error,
  ];

  PassengerPickupLocationUiState copyWith({
    bool? isLoading,
    String? userMessage,
    LatLng? currentLocation,
    LatLng? selectedPickupLocation,
    String? pickupAddress,
    GoogleMapController? mapController,
    bool? isCameraMoving,
    TextEditingController? searchController,
    TextEditingController? destinationController,
    TextEditingController? fromController,
    List<String>? searchSuggestions,
    List<String>? originSuggestions,
    String? error,
  }) {
    return PassengerPickupLocationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      currentLocation: currentLocation ?? this.currentLocation,
      selectedPickupLocation:
          selectedPickupLocation ?? this.selectedPickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      mapController: mapController ?? this.mapController,
      isCameraMoving: isCameraMoving ?? this.isCameraMoving,
      searchController: searchController ?? this.searchController,
      destinationController:
          destinationController ?? this.destinationController,
      fromController: fromController ?? this.fromController,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      originSuggestions: originSuggestions ?? this.originSuggestions,
      error: error ?? this.error,
    );
  }
}
