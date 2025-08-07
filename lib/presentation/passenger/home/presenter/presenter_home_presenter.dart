import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_services_usecase.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_ui_state.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_ui_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class PassengerHomePresenter extends BasePresenter<PassengerHomeUiState> {
  final GetPassengerServicesUseCase _getPassengerServicesUseCase;
  final GetCurrentLocationUsecase _getCurrentLocationUsecase;

  final Obs<PassengerHomeUiState> uiState = Obs<PassengerHomeUiState>(
    PassengerHomeUiState.empty(),
  );

  PassengerHomeUiState get currentUiState => uiState.value;
  Set<Marker> _markers = {};

  PassengerHomePresenter(
    this._getPassengerServicesUseCase,
    this._getCurrentLocationUsecase,
  );

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    loadPassengerServices();
    loadUserProfile();
  }

  // Method to refresh profile data when screen is focused
  Future<void> refreshUserProfile() async {
    await loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final ProfileModel? profile = await LocalStorage.getPassengerProfile();
    uiState.value = currentUiState.copyWith(
      userProfile: UserProfileData(
        name: profile?.name ?? '',
        email: profile?.email ?? '',
        phoneNumber: profile?.contact ?? '01625815151',
        avatarUrl:
            profile?.image != null
                ? ApiEndPoint.imageUrl + profile!.image!
                : ApiEndPoint.imageUrl + LocalStorage.myImage,
        dateOfBirth: '1990-01-01',
        gender: 'Male',
      ),
    );
  }

  void _addCurrentLocationMarker() {
    if (currentUiState.currentLocation != null) {
      final marker = Marker(
        markerId: const MarkerId('current_location'),
        position: currentUiState.currentLocation!,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      _markers = {marker};
    }
  }

  Set<Marker> get markers => _markers;

  // Helper method to get address from coordinates
  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      }
      return 'Address not found';
    } catch (e) {
      debugPrint('Error getting address: $e');
      return 'Unable to get address';
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await toggleLoading(loading: true);
      final result = await _getCurrentLocationUsecase.execute();

      result.fold(
        (error) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            error: error,
          );
          addUserMessage(
            'Unable to get your location. Using default location.',
          );
        },
        (locationEntity) async {
          final currentLatLng = LatLng(
            locationEntity.latitude,
            locationEntity.longitude,
          );

          // Get address string from coordinates
          final addressString = await getAddressFromLatLng(currentLatLng);

          uiState.value = currentUiState.copyWith(
            isLoading: false,
            currentLocation: currentLatLng,
            currentAddress: addressString,
            selectedPickupLocation:
                currentLatLng, // Set current location as initial pickup
          );

          // Add current location marker
          _addCurrentLocationMarker();
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      addUserMessage(e.toString());
    }
  }

  Future<void> loadPassengerServices() async {
    try {
      await toggleLoading(loading: true);
      final result = await _getPassengerServicesUseCase();

      result.fold(
        (failure) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            error: failure.message,
          );
          addUserMessage(failure.message);
        },
        (services) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            services: services,
            error: null,
          );
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      addUserMessage(e.toString());
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  // Method to update the pickup location data in the home presenter
  void updatePickupLocationData(LatLng location, String address) {
    uiState.value = currentUiState.copyWith(
      selectedPickupLocation: location,
      pickupAddress: address,
    );

    // Update markers
    final marker = Marker(
      markerId: const MarkerId('pickup_location'),
      position: location,
      infoWindow: InfoWindow(title: 'Pickup: $address'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    // Merge with existing markers
    final updatedMarkers = Set<Marker>.from(_markers);
    updatedMarkers.add(marker);
    _markers = updatedMarkers;
  }
}
