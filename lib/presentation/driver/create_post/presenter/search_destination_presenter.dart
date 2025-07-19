import 'dart:async';

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/create_post/presenter/search_destination_ui_state.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/set_ride_information_page.dart';
import 'package:cabwire/domain/entities/search_history_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchDestinationPresenter
    extends BasePresenter<SearchDestinationUiState> {
  final Obs<SearchDestinationUiState> uiState = Obs<SearchDestinationUiState>(
    SearchDestinationUiState.empty(),
  );
  SearchDestinationUiState get currentUiState => uiState.value;

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

  GoogleMapController? _mapController;

  SearchDestinationPresenter();

  @override
  void onInit() {
    super.onInit();
    _setupFromListener();
    _setupDestinationListener();

    // Set current location as pickup location if available
    if (currentUiState.currentLocation != null) {
      uiState.value = currentUiState.copyWith(
        selectedPickupLocation: currentUiState.currentLocation,
      );

      // Try to get address for current location
      _getAddressFromLatLng(currentUiState.currentLocation!)
          .then((address) {
            if (address != null && address.isNotEmpty) {
              // Update pickup address
              //uiState.value = currentUiState.copyWith(pickupAddress: address);

              // Update from controller text
              if (_fromListener != null) {
                currentUiState.fromController.removeListener(_fromListener!);
              }
              //currentUiState.fromController.text = address;
              if (_fromListener != null) {
                currentUiState.fromController.addListener(_fromListener!);
              }
            }
          })
          .catchError((error) {
            debugPrint('Error getting address for current location: $error');
          });
    }
  }

  void setServiceType(ServiceType serviceType) {
    uiState.value = currentUiState.copyWith(serviceType: serviceType);
  }

  void setServiceId(String? serviceId) {
    if (serviceId == null) {
      uiState.value = currentUiState.copyWith(
        serviceId: "686e008a153fae6071f36f28",
      );
    } else {
      uiState.value = currentUiState.copyWith(serviceId: serviceId);
    }
  }

  // Helper method to get address from coordinates
  Future<String?> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.name}, ${place.locality}, ${place.administrativeArea}';
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address from coordinates: $e');
      return null;
    }
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
          searchFromPlaces(query);
        });
      } else if (query.isEmpty) {
        // Clear suggestions when field is empty
        uiState.value = currentUiState.copyWith(fromSuggestions: []);
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
          searchDestinationPlaces(query);
        });
      } else if (query.isEmpty) {
        // Clear suggestions when field is empty
        uiState.value = currentUiState.copyWith(destinationSuggestions: []);
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

  Future<void> searchFromPlaces(String query) async {
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

          uiState.value = currentUiState.copyWith(fromSuggestions: suggestions);
        }
      }
    } catch (e) {
      debugPrint('Error searching from places: $e');
    } finally {
      _isSearching = false;
    }
  }

  Future<void> selectDestinationSuggestion(String placeDescription) async {
    try {
      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(destinationSuggestions: []);

      // Remove listener temporarily
      if (_destinationListener != null) {
        currentUiState.destinationController.removeListener(
          _destinationListener!,
        );
      }

      // Update the destinationController with the selected suggestion
      currentUiState.destinationController.text = placeDescription;

      // Re-add listener
      if (_destinationListener != null) {
        currentUiState.destinationController.addListener(_destinationListener!);
      }

      // Try to get coordinates for the selected location
      final locations = await locationFromAddress(placeDescription);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        // Store destination coordinates
        uiState.value = currentUiState.copyWith(
          destinationLocation: latLng,
          destinationAddress: placeDescription,
        );

        // If we have pickup location, calculate route
        if (currentUiState.selectedPickupLocation != null) {
          calculateRouteDistance(
            currentUiState.selectedPickupLocation!,
            latLng,
          );
          fetchRoutePolylines(currentUiState.selectedPickupLocation!, latLng);
          // Fit bounds to show both markers
          if (_mapController != null) {
            fitBoundsOnMap();
          }
        } else if (currentUiState.currentLocation != null) {
          // Use current location as pickup if no pickup was selected
          calculateRouteDistance(currentUiState.currentLocation!, latLng);
          fetchRoutePolylines(currentUiState.currentLocation!, latLng);
          // Fit bounds to show both markers
          if (_mapController != null) {
            fitBoundsOnMap();
          }
        }
      }
    } catch (e) {
      debugPrint('Error selecting destination place: $e');
    }
  }

  Future<void> selectFromSuggestion(String placeDescription) async {
    try {
      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(fromSuggestions: []);

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

        // Store pickup coordinates
        uiState.value = currentUiState.copyWith(
          selectedPickupLocation: latLng,
          pickupAddress: placeDescription,
        );

        // If we have destination location, calculate route
        if (currentUiState.destinationLocation != null) {
          calculateRouteDistance(latLng, currentUiState.destinationLocation!);
          fetchRoutePolylines(latLng, currentUiState.destinationLocation!);
          // Fit bounds to show both markers
          if (_mapController != null) {
            fitBoundsOnMap();
          }
        }
      }
    } catch (e) {
      debugPrint('Error selecting from place: $e');
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

  // Method to add multiple locations
  void addMultipleLocation() {
    // Create a new empty location entry
    final newLocation = MultipleLocationItem(address: '', coordinates: null);

    final updatedLocations = List<MultipleLocationItem>.from(
      currentUiState.multipleLocations,
    );
    updatedLocations.add(newLocation);

    uiState.value = currentUiState.copyWith(
      multipleLocations: updatedLocations,
    );
  }

  // Method to remove a location from multiple locations
  void removeMultipleLocation(int index) {
    if (index >= 0 && index < currentUiState.multipleLocations.length) {
      final updatedLocations = List<MultipleLocationItem>.from(
        currentUiState.multipleLocations,
      );
      updatedLocations.removeAt(index);

      uiState.value = currentUiState.copyWith(
        multipleLocations: updatedLocations,
      );
    }
  }

  // Method to update a specific multiple location
  void updateMultipleLocation(int index, String address, LatLng? coordinates) {
    if (index >= 0 && index < currentUiState.multipleLocations.length) {
      final updatedLocations = List<MultipleLocationItem>.from(
        currentUiState.multipleLocations,
      );

      updatedLocations[index] = MultipleLocationItem(
        address: address,
        coordinates: coordinates,
      );

      uiState.value = currentUiState.copyWith(
        multipleLocations: updatedLocations,
      );
    }
  }

  // Method to clear from field
  void clearFromField() {
    // Remove listener temporarily
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }

    // Clear from controller
    currentUiState.fromController.clear();

    // Re-add listener
    if (_fromListener != null) {
      currentUiState.fromController.addListener(_fromListener!);
    }

    // Clear from-related state
    uiState.value = currentUiState.copyWith(
      selectedPickupLocation: null,
      pickupAddress: null,
      fromSuggestions: [],
      routeDistance: null,
      routeDuration: null,
      routePolylines: null,
    );
  }

  // Method to clear destination field
  void clearDestinationField() {
    // Remove listener temporarily
    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    // Clear destination controller
    currentUiState.destinationController.clear();

    // Re-add listener
    if (_destinationListener != null) {
      currentUiState.destinationController.addListener(_destinationListener!);
    }

    // Clear destination-related state
    uiState.value = currentUiState.copyWith(
      destinationLocation: null,
      destinationAddress: null,
      destinationSuggestions: [],
      routeDistance: null,
      routeDuration: null,
      routePolylines: null,
    );
  }

  // Method to clear all fields
  void clearAllFields() {
    // Remove listeners temporarily
    if (_fromListener != null) {
      currentUiState.fromController.removeListener(_fromListener!);
    }
    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    // Clear text controllers
    currentUiState.fromController.clear();
    currentUiState.destinationController.clear();

    // Re-add listeners
    if (_fromListener != null) {
      currentUiState.fromController.addListener(_fromListener!);
    }
    if (_destinationListener != null) {
      currentUiState.destinationController.addListener(_destinationListener!);
    }

    // Clear state
    uiState.value = currentUiState.copyWith(
      selectedPickupLocation: null,
      destinationLocation: null,
      pickupAddress: null,
      destinationAddress: null,
      fromSuggestions: [],
      destinationSuggestions: [],
      originSuggestions: [],
      routeDistance: null,
      routeDuration: null,
      routePolylines: null,
      multipleLocations: [],
    );
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

      // Re-add listener
      if (_destinationListener != null) {
        currentUiState.destinationController.addListener(_destinationListener!);
      }

      // Try to get coordinates for the selected location
      final locations = await locationFromAddress(placeDescription);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        // Store destination coordinates for route calculation
        uiState.value = currentUiState.copyWith(
          destinationLocation: latLng,
          destinationAddress: placeDescription,
        );

        // If we have pickup location, calculate route
        if (currentUiState.selectedPickupLocation != null) {
          calculateRouteDistance(
            currentUiState.selectedPickupLocation!,
            latLng,
          );
          fetchRoutePolylines(currentUiState.selectedPickupLocation!, latLng);
          // Fit bounds to show both markers
          if (_mapController != null) {
            fitBoundsOnMap();
          }
        } else if (currentUiState.currentLocation != null) {
          // Use current location as pickup if no pickup was selected
          calculateRouteDistance(currentUiState.currentLocation!, latLng);
          fetchRoutePolylines(currentUiState.currentLocation!, latLng);
          // Fit bounds to show both markers
          if (_mapController != null) {
            fitBoundsOnMap();
          }
        }
      }
    } catch (e) {
      debugPrint('Error selecting origin place: $e');
    }
  }

  void navigateToCarTypeSelection(BuildContext context, Widget? nextScreen) {
    // Validate that pickup and dropoff locations are different
    if (currentUiState.destinationLocation != null &&
        currentUiState.selectedPickupLocation != null) {
      // Check if pickup and dropoff locations are the same
      final pickupLocation = currentUiState.selectedPickupLocation!;
      final destinationLocation = currentUiState.destinationLocation!;

      if (pickupLocation.latitude == destinationLocation.latitude &&
          pickupLocation.longitude == destinationLocation.longitude) {
        showMessage(message: 'Pickup and dropoff locations cannot be the same');
        return;
      }
    } else {
      showMessage(message: 'Please select both pickup and dropoff locations');
    }
  }

  // Package delivery methods

  Future<void> navigateToPackageDelivery(BuildContext context) async {
    // final apiService = locate<ApiService>();
    // final body = {
    //   'pickupLocation': {
    //     'lat': currentUiState.selectedPickupLocation?.latitude,
    //     'lng': currentUiState.selectedPickupLocation?.longitude,
    //     'address': currentUiState.pickupAddress,
    //   },
    //   'dropoffLocation': {
    //     'lat': currentUiState.destinationLocation?.latitude,
    //     'lng': currentUiState.destinationLocation?.longitude,
    //     'address': currentUiState.destinationAddress,
    //   },
    //   'paymentMethod': 'stripe',
    // };
  }

  void onDestinationMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // If we already have start and end points, fit bounds
    if (currentUiState.currentLocation != null &&
        currentUiState.destinationLocation != null) {
      fitBoundsOnMap();
    }
  }

  void clearDestination() {
    // Remove listener temporarily
    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    // Clear destination text
    currentUiState.destinationController.clear();

    // Re-add listener
    if (_destinationListener != null) {
      currentUiState.destinationController.addListener(_destinationListener!);
    }

    // Clear destination-related data
    uiState.value = currentUiState.copyWith(
      originLocation: null,
      originAddress: null,
      originSuggestions: [],
      routeDistance: null,
      routeDuration: null,
      routePolylines: null,
    );
  }

  void selectHistoryItem(SearchHistoryItem item) {
    // Fill in the destination controller with the location from history
    if (_destinationListener != null) {
      currentUiState.destinationController.removeListener(
        _destinationListener!,
      );
    }

    currentUiState.destinationController.text = item.location;

    if (_destinationListener != null) {
      currentUiState.destinationController.addListener(_destinationListener!);
    }

    // Use geocoding to get coordinates for this location
    locationFromAddress(item.location)
        .then((locations) {
          if (locations.isNotEmpty) {
            final location = locations.first;
            final latLng = LatLng(location.latitude, location.longitude);

            // Store as destination (not origin!)
            uiState.value = currentUiState.copyWith(
              destinationLocation: latLng,
              destinationAddress: item.location,
            );

            // Calculate route if we have pickup location
            if (currentUiState.selectedPickupLocation != null) {
              calculateRouteDistance(
                currentUiState.selectedPickupLocation!,
                latLng,
              );
              fetchRoutePolylines(
                currentUiState.selectedPickupLocation!,
                latLng,
              );
            } else if (currentUiState.currentLocation != null) {
              // Use current location as pickup if no pickup was selected
              calculateRouteDistance(currentUiState.currentLocation!, latLng);
              fetchRoutePolylines(currentUiState.currentLocation!, latLng);
            }

            // Fit bounds to show both markers
            if (_mapController != null) {
              fitBoundsOnMap();
            }
          }
        })
        .catchError((e) {
          debugPrint('Error getting coordinates for history item: $e');
        });
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
    appLog('address: $address');
    appLog('pickupLocation: ${pickupLocation.toString()}');
    appLog(
      'currentUiState.fromController.text: ${currentUiState.fromController.text}',
    );

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

  void handleContinuePress(BuildContext context) {
    // Debug logging to see current state
    debugPrint('=== Continue Press Debug ===');
    debugPrint(
      'selectedPickupLocation: ${currentUiState.selectedPickupLocation}',
    );
    debugPrint('destinationLocation: ${currentUiState.destinationLocation}');
    debugPrint('fromController.text: ${currentUiState.fromController.text}');
    debugPrint(
      'destinationController.text: ${currentUiState.destinationController.text}',
    );
    debugPrint('pickupAddress: ${currentUiState.pickupAddress}');
    debugPrint('destinationAddress: ${currentUiState.destinationAddress}');

    // Check if we have both pickup and destination
    if (currentUiState.selectedPickupLocation == null &&
        currentUiState.fromController.text.isEmpty) {
      addUserMessage('Please select a pickup location');
      return;
    }

    if (currentUiState.destinationLocation == null &&
        currentUiState.destinationController.text.isEmpty) {
      addUserMessage('Please select a dropoff location');
      return;
    }

    // If we have text but no coordinates, try to get coordinates
    if (currentUiState.destinationController.text.isNotEmpty &&
        currentUiState.destinationLocation == null) {
      addUserMessage('Please wait while we process your destination location');
      return;
    }

    if (currentUiState.fromController.text.isNotEmpty &&
        currentUiState.selectedPickupLocation == null) {
      addUserMessage('Please wait while we process your pickup location');
      return;
    }

    // Validate that pickup and dropoff locations are different
    if (currentUiState.destinationLocation != null &&
        currentUiState.selectedPickupLocation != null) {
      final pickupLocation = currentUiState.selectedPickupLocation!;
      final destinationLocation = currentUiState.destinationLocation!;

      if (pickupLocation.latitude == destinationLocation.latitude &&
          pickupLocation.longitude == destinationLocation.longitude) {
        addUserMessage('Pickup and dropoff locations cannot be the same');
        return;
      }
    }

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SetRideInformationScreen(
              pickupLocation: currentUiState.selectedPickupLocation!,
              pickupAddress: currentUiState.pickupAddress!,
              destinationLocations: [currentUiState.destinationLocation!],
              destinationAddresses: [currentUiState.destinationAddress!],
            ),
      ),
    );
  }

  // Method to fit map bounds to show both markers
  void fitBoundsOnMap() {
    if (_mapController == null) {
      debugPrint('Map controller is null, cannot fit bounds');
      return;
    }

    // Determine which points to include in bounds
    List<LatLng> points = [];

    // Add current location if available
    if (currentUiState.currentLocation != null) {
      points.add(currentUiState.currentLocation!);
    }

    // Add pickup location if available and different from current
    if (currentUiState.selectedPickupLocation != null) {
      points.add(currentUiState.selectedPickupLocation!);
    }

    // Add destination location if available
    if (currentUiState.destinationLocation != null) {
      points.add(currentUiState.destinationLocation!);
    }

    // Need at least 2 points to create bounds
    if (points.length < 2) {
      debugPrint('Not enough points to create bounds: ${points.length}');
      return;
    }

    // Find min and max coordinates
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Create bounds
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Animate camera with padding
    try {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      debugPrint('Camera animated to show bounds');
    } catch (e) {
      debugPrint('Error fitting bounds: $e');
    }
  }

  // Method to fetch and decode polyline points
  Future<void> fetchRoutePolylines(LatLng origin, LatLng destination) async {
    debugPrint(
      'Fetching route from ${origin.latitude},${origin.longitude} to ${destination.latitude},${destination.longitude}',
    );

    if (origin.latitude == destination.latitude &&
        origin.longitude == destination.longitude) {
      debugPrint('Origin and destination are the same, skipping route');
      return;
    }

    if (_isSearching) {
      debugPrint('Already searching for route, skipping');
      return;
    }

    _isSearching = true;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$_googleApiKey'
        '&mode=driving'
        '&alternatives=false',
      );

      debugPrint('Calling Directions API: ${url.toString()}');

      final response = await _httpClient
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('API request timed out'),
          );

      debugPrint('Directions API response code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Directions API status: ${data['status']}');

        if (data['status'] == 'OK') {
          // Get route and decode polyline
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            // Get overview polyline points
            final points = routes[0]['overview_polyline']['points'];
            debugPrint('Received polyline points: ${points.length} characters');

            // Decode polyline points
            final polylineCoordinates = _decodePolyline(points);
            debugPrint('Decoded ${polylineCoordinates.length} polyline points');

            if (polylineCoordinates.isEmpty) {
              debugPrint('No polyline coordinates were decoded');
              // If no polyline coordinates are available, create a direct line
              polylineCoordinates.add(origin);
              polylineCoordinates.add(destination);
              debugPrint('Created direct line with 2 points as fallback');
            }

            // Update state with polyline coordinates
            uiState.value = currentUiState.copyWith(
              routePolylines: polylineCoordinates,
            );

            // Update the map to show the entire route
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_mapController != null) {
                fitBoundsOnMap();
              }
            });
          } else {
            debugPrint('No routes found in the response');
            // Fallback: create a direct line
            _createFallbackRoute(origin, destination);
          }
        } else if (data['status'] == 'ZERO_RESULTS') {
          debugPrint('No route found between these points');
          // Fallback: create a direct line
          _createFallbackRoute(origin, destination);
        } else {
          debugPrint('Directions API error: ${data['status']}');
          // Fallback: create a direct line
          _createFallbackRoute(origin, destination);
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        // Fallback: create a direct line
        _createFallbackRoute(origin, destination);
      }
    } catch (e) {
      debugPrint('Error fetching route polylines: $e');
      // Fallback: create a direct line
      _createFallbackRoute(origin, destination);
    } finally {
      _isSearching = false;
    }
  }

  // Helper method to create a direct line between two points as fallback
  void _createFallbackRoute(LatLng origin, LatLng destination) {
    final List<LatLng> directRoute = [origin, destination];
    uiState.value = currentUiState.copyWith(routePolylines: directRoute);

    // Update the map to show this direct route
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_mapController != null) {
        fitBoundsOnMap();
      }
    });
  }

  // Helper method to decode polyline string
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final point = LatLng(lat / 1E5, lng / 1E5);

      polylinePoints.add(point);
    }

    return polylinePoints;
  }
}
