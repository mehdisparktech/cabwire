import 'dart:async';

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/location/get_current_location_usecase.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_pickup_location_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PassengerPickupLocationPresenter
    extends BasePresenter<PassengerPickupLocationUiState> {
  final GetCurrentLocationUsecase _getCurrentLocationUsecase;
  final Obs<PassengerPickupLocationUiState> uiState =
      Obs<PassengerPickupLocationUiState>(
        PassengerPickupLocationUiState.empty(),
      );
  PassengerPickupLocationUiState get currentUiState => uiState.value;

  Timer? _debounceTimer;
  Set<Marker> _markers = {};
  bool _isSearching = false;
  bool _isLoadingLocation = false;
  VoidCallback? _searchListener;

  // For production, replace this with actual Google Maps API key
  static final String _googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final http.Client _httpClient = http.Client();

  PassengerPickupLocationPresenter(this._getCurrentLocationUsecase);

  @override
  void onInit() {
    super.onInit();
    _setupSearchListener();
    getCurrentLocation();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();

    // Remove all listeners from controllers
    if (_searchListener != null) {
      currentUiState.searchController.removeListener(_searchListener!);
    }

    // Dispose controllers and map properly
    currentUiState.mapController?.dispose();

    // Close HTTP client
    _httpClient.close();

    super.onClose();
  }

  void _setupSearchListener() {
    // Remove any existing listener first
    if (_searchListener != null) {
      currentUiState.searchController.removeListener(_searchListener!);
    }

    // Create and store the listener function
    _searchListener = () {
      final query = currentUiState.searchController.text;
      if (query.isNotEmpty && query.length > 2) {
        if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          searchPlaces(query);
        });
      } else if (query.isEmpty) {
        // Clear suggestions when search is empty
        uiState.value = currentUiState.copyWith(searchSuggestions: []);
      }
    };

    // Add the listener
    currentUiState.searchController.addListener(_searchListener!);
  }

  void onMapCreated(GoogleMapController controller) {
    // First dispose any existing controller to prevent memory leaks
    currentUiState.mapController?.dispose();

    uiState.value = currentUiState.copyWith(mapController: controller);
    _addCurrentLocationMarker();
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

  Future<void> getCurrentLocation() async {
    // Prevent duplicate location requests
    if (_isLoadingLocation) return;

    _isLoadingLocation = true;
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
        (locationEntity) {
          final currentLatLng = LatLng(
            locationEntity.latitude,
            locationEntity.longitude,
          );

          uiState.value = currentUiState.copyWith(
            isLoading: false,
            currentLocation: currentLatLng,
            selectedPickupLocation:
                currentLatLng, // Set current location as initial pickup
          );

          // Move camera to current location
          moveCamera(currentLatLng);

          // Get address for the current location
          getAddressFromLatLng(currentLatLng);

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
    } finally {
      _isLoadingLocation = false;
    }
  }

  void moveCamera(LatLng position) {
    if (currentUiState.mapController != null) {
      currentUiState.mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16.0),
        ),
      );
    }
  }

  void onMapTap(LatLng position) {
    uiState.value = currentUiState.copyWith(selectedPickupLocation: position);
    _updatePickupLocationMarker(position);
    getAddressFromLatLng(position);
  }

  void _updatePickupLocationMarker(LatLng position) {
    final currentLocationMarker = _markers.firstWhere(
      (marker) => marker.markerId.value == 'current_location',
      orElse:
          () => Marker(
            markerId: const MarkerId('current_location'),
            position: currentUiState.currentLocation ?? const LatLng(0, 0),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
    );

    final pickupMarker = Marker(
      markerId: const MarkerId('pickup_location'),
      position: position,
      infoWindow: const InfoWindow(title: 'Pickup Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    _markers = {currentLocationMarker, pickupMarker};
  }

  void onCameraMove(CameraPosition position) {
    uiState.value = currentUiState.copyWith(isCameraMoving: true);
  }

  void onCameraIdle() {
    uiState.value = currentUiState.copyWith(isCameraMoving: false);
    if (currentUiState.mapController != null) {
      // Limit how frequently we update location on camera idle
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        currentUiState.mapController!.getVisibleRegion().then((bounds) {
          // Get the center of the visible region
          final center = LatLng(
            (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
          );

          uiState.value = currentUiState.copyWith(
            selectedPickupLocation: center,
          );
          _updatePickupLocationMarker(center);
          getAddressFromLatLng(center);
        });
      });
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';

        // Remove search listener temporarily to avoid feedback loops
        if (_searchListener != null) {
          currentUiState.searchController.removeListener(_searchListener!);
        }

        // Update state with new address
        uiState.value = currentUiState.copyWith(pickupAddress: address);

        // Update the search controller text with the new address
        currentUiState.searchController.text = address;

        // Re-add the listener after updating the text field
        if (_searchListener != null) {
          currentUiState.searchController.addListener(_searchListener!);
        }
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      uiState.value = currentUiState.copyWith(
        pickupAddress: 'Address not available',
      );
    }
  }

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty || _isSearching) return;

    _isSearching = true;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$query'
        '&key=$_googleApiKey'
        '&language=en'
        '&components=country:bd', // Limit to Bangladesh
      );

      final response = await _httpClient
          .get(url)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          final suggestions =
              predictions.map((p) => p['description'].toString()).toList();

          uiState.value = currentUiState.copyWith(
            searchSuggestions: suggestions,
          );
        } else {
          debugPrint('Place Autocomplete API error: ${data['status']}');
        }
      }
    } catch (e) {
      debugPrint('Error searching places: $e');
    } finally {
      _isSearching = false;
    }
  }

  Future<void> selectSearchResult(String placeDescription) async {
    try {
      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(searchSuggestions: []);

      // Get location from place description
      final locations = await locationFromAddress(placeDescription);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        // Remove listener temporarily to avoid infinite loops
        if (_searchListener != null) {
          currentUiState.searchController.removeListener(_searchListener!);
        }

        // Update search controller
        currentUiState.searchController.text = placeDescription;

        // Update state
        uiState.value = currentUiState.copyWith(
          selectedPickupLocation: latLng,
          pickupAddress: placeDescription,
        );

        // Re-add listener
        if (_searchListener != null) {
          currentUiState.searchController.addListener(_searchListener!);
        }

        // Move camera to selected location
        moveCamera(latLng);

        // Update marker
        _updatePickupLocationMarker(latLng);
      }
    } catch (e) {
      debugPrint('Error selecting place: $e');
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
}
