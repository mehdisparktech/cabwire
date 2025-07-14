import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_ui_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerHomeUiState extends BaseUiState {
  final List<PassengerServiceEntity> services;
  final String? error;
  final PassengerCategoryEntity? selectedCategory;
  final LatLng? currentLocation;
  final String? currentAddress;
  final LatLng? selectedPickupLocation;
  final LatLng? destinationLocation;
  final String? pickupAddress;
  final GoogleMapController? mapController;
  final UserProfileData? userProfile;

  const PassengerHomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.services,
    this.error,
    this.selectedCategory,
    this.currentLocation,
    this.currentAddress,
    this.selectedPickupLocation,
    this.destinationLocation,
    this.pickupAddress,
    this.mapController,
    this.userProfile,
  });

  factory PassengerHomeUiState.empty() {
    return PassengerHomeUiState(
      isLoading: false,
      userMessage: '',
      services: [],
      error: null,
      selectedCategory: null,
      currentLocation: const LatLng(23.8103, 90.4125), // Default location
      selectedPickupLocation: null,
      destinationLocation: null,
      pickupAddress: null,
      mapController: null,
      userProfile: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    services,
    error,
    selectedCategory,
    currentLocation,
    currentAddress,
    selectedPickupLocation,
    destinationLocation,
    pickupAddress,
    mapController,
    userProfile,
  ];

  PassengerHomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<PassengerServiceEntity>? services,
    String? error,
    PassengerCategoryEntity? selectedCategory,
    LatLng? currentLocation,
    String? currentAddress,
    LatLng? selectedPickupLocation,
    LatLng? destinationLocation,
    String? pickupAddress,
    GoogleMapController? mapController,
    UserProfileData? userProfile,
  }) {
    return PassengerHomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      services: services ?? this.services,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentLocation: currentLocation ?? this.currentLocation,
      currentAddress: currentAddress ?? this.currentAddress,
      selectedPickupLocation:
          selectedPickupLocation ?? this.selectedPickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      mapController: mapController ?? this.mapController,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
