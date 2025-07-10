import 'dart:async';

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/choose_car_type_screen.dart';
import 'package:cabwire/presentation/passenger/home/presenter/passenger_drop_location_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PassengerDropLocationPresenter
    extends BasePresenter<PassengerDropLocationUiState> {
  final Obs<PassengerDropLocationUiState> uiState =
      Obs<PassengerDropLocationUiState>(PassengerDropLocationUiState.empty());
  PassengerDropLocationUiState get currentUiState => uiState.value;

  Timer? _debounceTimer;

  // HTTP client for better reuse and connection management
  final http.Client _httpClient = http.Client();

  // Flag to prevent redundant API calls
  bool _isSearching = false;

  // For production, replace this with actual Google Maps API key
  static const String _googleApiKey = 'AIzaSyBVd7ggzUDHSxsiQ0tsB1IBxteOXyiz_uU';

  // Listener callback
  VoidCallback? _fromListener;
  VoidCallback? _destinationListener;

  PassengerDropLocationPresenter();

  @override
  void onInit() {
    super.onInit();
    _setupFromListener();
    _setupDestinationListener();
  }

  @override
  void onClose() {
    // Cancel all subscriptions and timers
    _debounceTimer?.cancel();

    // Remove all listeners from controllers
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }

    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    // Close HTTP client
    _httpClient.close();

    super.onClose();
  }

  void _setupFromListener() {
    // Remove any existing listeners first
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }

    // Create and store the "from" listener
    _fromListener = () {
      final query = currentUiState.fromController.text;
      if (query.isNotEmpty && query.length > 2) {
        if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          searchDestinationPlaces(query);
        });
      } else if (query.isEmpty) {
        // Clear suggestions when field is empty
        uiState.value = currentUiState.copyWith(destinationSuggestions: []);
      }
    };

    // Add the listeners
    currentUiState.fromController.addListener(_fromListener!);
  }

  void _setupDestinationListener() {
    // Remove any existing listeners first
    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    // Create and store the destination listener
    _destinationListener = () {
      final query = currentUiState.destinationController.text;
      if (query.isNotEmpty && query.length > 2) {
        if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          searchOriginPlaces(query);
        });
      } else if (query.isEmpty) {
        // Clear suggestions when field is empty
        uiState.value = currentUiState.copyWith(originSuggestions: []);
      }
    };

    // Add the listener
    currentUiState.destinationController.addListener(_destinationListener!);
  }

  void setCurrentLocation(LatLng location) {
    uiState.value = currentUiState.copyWith(currentLocation: location);
  }

  Future<void> searchDestinationPlaces(String query) async {
    if (query.isEmpty || _isSearching) return;

    _isSearching = true;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$query'
        '&key=$_googleApiKey'
        '&language=en'
        '&components=country:bd',
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
            destinationSuggestions: suggestions,
          );
        }
      }
    } catch (e) {
      debugPrint('Error searching destination places: $e');
    } finally {
      _isSearching = false;
    }
  }

  Future<void> selectDestinationSuggestion(String placeDescription) async {
    try {
      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(destinationSuggestions: []);

      // Remove listener temporarily
      if (_fromListener != null) {
        currentUiState.fromController.removeListener(_fromListener!);
      }

      // Update the fromController with the selected suggestion
      currentUiState.fromController.text = placeDescription;

      // Re-add listener
      if (_fromListener != null) {
        currentUiState.fromController.addListener(_fromListener!);
      }

      // Try to get coordinates for the selected location
      final locations = await locationFromAddress(placeDescription);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        // Store destination coordinates for route calculation later
        uiState.value = currentUiState.copyWith(
          destinationLocation: latLng,
          destinationAddress: placeDescription,
        );

        // If we have pickup location (from the main presenter), calculate route
        if (currentUiState.currentLocation != null) {
          calculateRouteDistance(currentUiState.currentLocation!, latLng);
        }
      }
    } catch (e) {
      debugPrint('Error selecting destination place: $e');
    }
  }

  Future<void> calculateRouteDistance(LatLng origin, LatLng destination) async {
    if (_isSearching) return;

    _isSearching = true;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=${origin.latitude},${origin.longitude}'
        '&destinations=${destination.latitude},${destination.longitude}'
        '&key=$_googleApiKey'
        '&mode=driving',
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
          final rows = data['rows'] as List;
          if (rows.isNotEmpty) {
            final elements = rows[0]['elements'] as List;
            if (elements.isNotEmpty) {
              final element = elements[0];
              final distance = element['distance']['text'];
              final duration = element['duration']['text'];

              uiState.value = currentUiState.copyWith(
                routeDistance: distance,
                routeDuration: duration,
              );

              // Add this route to search history if not already present
              addToSearchHistory(currentUiState.fromController.text, distance);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error calculating route distance: $e');
    } finally {
      _isSearching = false;
    }
  }

  void addToSearchHistory(String destination, String distance) {
    // Check if this destination already exists
    final exists = currentUiState.searchHistory.any(
      (item) => item.location == destination,
    );

    if (!exists) {
      final newHistory = SearchHistoryItem(
        location: destination,
        distance: distance,
      );

      final updatedHistory = List<SearchHistoryItem>.from(
        currentUiState.searchHistory,
      );
      updatedHistory.insert(0, newHistory); // Add to beginning of list

      // Limit history to 10 items
      if (updatedHistory.length > 10) {
        updatedHistory.removeLast();
      }

      uiState.value = currentUiState.copyWith(searchHistory: updatedHistory);
    }
  }

  Future<void> searchOriginPlaces(String query) async {
    if (query.isEmpty || _isSearching) return;

    _isSearching = true;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$query'
        '&key=$_googleApiKey'
        '&language=en'
        '&components=country:bd',
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
            originSuggestions: suggestions,
          );
        }
      }
    } catch (e) {
      debugPrint('Error searching origin places: $e');
    } finally {
      _isSearching = false;
    }
  }

  Future<void> selectOriginSuggestion(String placeDescription) async {
    try {
      debugPrint(
        "=== selectOriginSuggestion called with: $placeDescription ===",
      );

      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(originSuggestions: []);

      // Remove listener temporarily
      if (_destinationListener != null) {
        currentUiState.destinationController.removeListener(
          _destinationListener!,
        );
      }

      // Update the destinationController with the selected suggestion
      currentUiState.destinationController.text = placeDescription;
      debugPrint(
        "=== Destination controller text set to: ${currentUiState.destinationController.text} ===",
      );

      // Re-add listener
      if (_destinationListener != null) {
        currentUiState.destinationController.addListener(_destinationListener!);
      }

      // Try to get coordinates for the selected location
      final locations = await locationFromAddress(placeDescription);
      debugPrint("=== Got locations: $locations ===");

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        debugPrint("=== Setting origin location to: $latLng ===");

        // Store origin coordinates for route calculation later
        uiState.value = currentUiState.copyWith(
          originLocation: latLng,
          originAddress: placeDescription,
          // Also update destination location since this is the destination field
          destinationLocation: latLng,
          destinationAddress: placeDescription,
        );
        debugPrint("=== Updated UI state with origin location ===");

        // If we have pickup location (current location), calculate route
        if (currentUiState.currentLocation != null) {
          debugPrint("=== Calculating route distance ===");
          calculateRouteDistance(currentUiState.currentLocation!, latLng);
        } else {
          debugPrint(
            "=== No current location available for route calculation ===",
          );
        }
      }
    } catch (e) {
      debugPrint("=== Error selecting origin place: $e ===");
      // Add error handling to show the user what went wrong
      addUserMessage('Failed to get location data: ${e.toString()}');
    }
  }

  void navigateToCarTypeSelection(BuildContext context, Widget? nextScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                nextScreen ??
                ChooseCarTypeScreen(
                  serviceId: '686e008a153fae6071f36f28',
                  pickupLocation: currentUiState.originLocation!,
                  pickupAddress: currentUiState.originAddress!,
                  dropoffLocation: currentUiState.destinationLocation!,
                  dropoffAddress: currentUiState.destinationAddress!,
                ),
      ),
    );
  }

  void onDestinationMapCreated(GoogleMapController controller) {
    // Don't store this controller as it's not needed
    // Just ensure map settings are applied
    // ignore: deprecated_member_use
    controller.setMapStyle(null); // Use default style
  }

  void clearDestination() {
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }

    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    // Clear appropriate field based on which one has focus
    if (currentUiState.fromController.text.isNotEmpty) {
      currentUiState.fromController.clear();
    } else if (currentUiState.destinationController.text.isNotEmpty) {
      currentUiState.destinationController.clear();
    }

    // Re-add listeners
    if (_fromListener != null) {
      currentUiState.fromController.addListener(_fromListener!);
    }

    if (_destinationListener != null) {
      currentUiState.destinationController.addListener(_destinationListener!);
    }

    uiState.value = currentUiState.copyWith(
      destinationSuggestions: [],
      originSuggestions: [],
      destinationLocation: null,
      originLocation: null,
      originAddress: null,
      routeDistance: null,
      routeDuration: null,
    );
  }

  void selectHistoryItem(SearchHistoryItem item) {
    // Remove listener temporarily
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }

    currentUiState.fromController.text = item.location;

    // Re-add listener
    if (_fromListener != null) {
      currentUiState.fromController.addListener(_fromListener!);
    }

    // If we already have coordinates for this location in history,
    // we could retrieve them here and update the state
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

  // Method to update pickup location from the pickup location screen
  void updatePickupLocation(LatLng pickupLocation, String address) {
    // Update the pickup location and address in the state
    uiState.value = currentUiState.copyWith(
      selectedPickupLocation: pickupLocation,
      pickupAddress: address,
      currentLocation:
          pickupLocation, // Also set as current location for distance calculation
    );

    // Update the from controller text with the address
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }

    currentUiState.fromController.text = address;

    // Re-add the listener
    if (_fromListener != null) {
      currentUiState.fromController.addListener(_fromListener!);
    }

    // If there's already a destination set, calculate the route
    if (currentUiState.destinationLocation != null) {
      calculateRouteDistance(
        currentUiState.selectedPickupLocation!,
        currentUiState.destinationLocation!,
      );
    }
  }

  void handleContinuePress(BuildContext context, Widget? nextScreen) {
    if (currentUiState.destinationLocation != null) {
      navigateToCarTypeSelection(context, nextScreen);
    }
  }
}
