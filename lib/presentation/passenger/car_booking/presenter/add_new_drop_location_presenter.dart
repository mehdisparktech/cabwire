import 'dart:async';
import 'dart:math' as math;

import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/presentation/passenger/car_booking/presenter/add_new_drop_location_ui_state.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/choose_car_type_screen.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/finding_rides_screen.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/ride_share/ride_share_car_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNewDropLocationPresenter
    extends BasePresenter<AddNewDropLocationUiState> {
  final Obs<AddNewDropLocationUiState> uiState = Obs<AddNewDropLocationUiState>(
    AddNewDropLocationUiState.empty(),
  );
  AddNewDropLocationUiState get currentUiState => uiState.value;

  Timer? _debounceTimer;

  // HTTP client for better reuse and connection management
  final http.Client _httpClient = http.Client();

  // Flag to prevent redundant API calls
  bool _isSearching = false;

  // Flag to track if controllers are disposed
  bool _isDisposed = false;

  // For production, replace this with actual Google Maps API key
  static final String _googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  // Controllers for text fields

  final TextEditingController fromController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // Listener callback
  VoidCallback? _fromListener;
  VoidCallback? _destinationListener;

  GoogleMapController? _mapController;

  AddNewDropLocationPresenter();

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
                fromController.removeListener(_fromListener!);
              }
              //currentUiState.fromController.text = address;
              if (_fromListener != null) {
                fromController.addListener(_fromListener!);
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

  void setPickupAddress(String? pickupAddress) {
    uiState.value = currentUiState.copyWith(pickupAddress: pickupAddress);
  }

  void setPickupLocation(LatLng? pickupLocation) {
    uiState.value = currentUiState.copyWith(
      selectedPickupLocation: pickupLocation,
    );
    fromController.text = pickupLocation?.latitude.toString() ?? '';
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
    // Set disposal flag to prevent further operations
    _isDisposed = true;

    // Cancel all subscriptions and timers
    _debounceTimer?.cancel();

    // Remove all listeners from controllers if they haven't been disposed yet
    try {
      if (_fromListener != null) {
        fromController.removeListener(_fromListener!);
        _fromListener = null;
      }

      if (_destinationListener != null) {
        destinationController.removeListener(_destinationListener!);
        _destinationListener = null;
      }
      _mapController?.dispose();
      _mapController = null;
    } catch (e) {
      // Controllers may have already been disposed, ignore the error
      debugPrint('Error removing listeners: $e');
    }

    // Dispose controllers to prevent memory leaks
    try {
      fromController.dispose();
      destinationController.dispose();
      searchController.dispose();
    } catch (e) {
      // Controllers may have already been disposed, ignore the error
      debugPrint('Controllers already disposed: $e');
    }

    // Close HTTP client
    try {
      _httpClient.close();
    } catch (e) {
      // HTTP client may have already been closed, ignore the error
      debugPrint('HTTP client already closed: $e');
    }

    super.onClose();
  }

  /// Reset all data to initial state and clean controllers
  void resetToInitialState() {
    if (_isDisposed) return;

    // Cancel any ongoing operations
    _debounceTimer?.cancel();
    _isSearching = false;

    // Remove listeners temporarily
    try {
      if (_fromListener != null) {
        fromController.removeListener(_fromListener!);
        _fromListener = null;
      }
      if (_destinationListener != null) {
        destinationController.removeListener(_destinationListener!);
        _destinationListener = null;
      }
    } catch (e) {
      debugPrint('Error removing listeners during reset: $e');
    }

    // Clear controller text instead of disposing them
    try {
      fromController.clear();
      destinationController.clear();
      searchController.clear();
    } catch (e) {
      debugPrint('Error clearing controllers during reset: $e');
    }

    // Reset state to initial values
    uiState.value = AddNewDropLocationUiState.empty();

    // Re-setup listeners
    _setupFromListener();
    _setupDestinationListener();

    // Clear map controller reference
    _mapController = null;

    debugPrint('AddNewDropLocationPresenter: State reset to initial values');
  }

  void _setupFromListener() {
    if (_isDisposed) return;

    // Remove any existing listeners first
    if (_fromListener != null) {
      try {
        fromController.removeListener(_fromListener!);
      } catch (e) {
        debugPrint('Error removing from listener: $e');
      }
    }

    // Create and store the "from" listener
    _fromListener = () {
      if (_isDisposed) return;

      try {
        final query = fromController.text;
        if (query.isNotEmpty && query.length > 2) {
          if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 500), () {
            if (!_isDisposed) {
              searchDestinationPlaces(query);
            }
          });
        } else if (query.isEmpty) {
          // Clear suggestions when field is empty
          if (!_isDisposed) {
            uiState.value = currentUiState.copyWith(destinationSuggestions: []);
          }
        }
      } catch (e) {
        debugPrint('Error in from listener: $e');
      }
    };

    // Add the listeners
    try {
      fromController.addListener(_fromListener!);
    } catch (e) {
      debugPrint('Error adding from listener: $e');
    }
  }

  void _setupDestinationListener() {
    if (_isDisposed) return;

    // Remove any existing listeners first
    if (_destinationListener != null) {
      try {
        destinationController.removeListener(_destinationListener!);
      } catch (e) {
        debugPrint('Error removing destination listener: $e');
      }
    }

    // Create and store the destination listener
    _destinationListener = () {
      if (_isDisposed) return;

      try {
        final query = destinationController.text;
        if (query.isNotEmpty && query.length > 2) {
          if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 500), () {
            if (!_isDisposed) {
              searchOriginPlaces(query);
            }
          });
        } else if (query.isEmpty) {
          // Clear suggestions when field is empty
          if (!_isDisposed) {
            uiState.value = currentUiState.copyWith(originSuggestions: []);
          }
        }
      } catch (e) {
        debugPrint('Error in destination listener: $e');
      }
    };

    // Add the listener
    try {
      destinationController.addListener(_destinationListener!);
    } catch (e) {
      debugPrint('Error adding destination listener: $e');
    }
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
        '&language=en',
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
    if (_isDisposed) return;

    try {
      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(destinationSuggestions: []);

      // Remove listener temporarily
      if (_fromListener != null) {
        try {
          fromController.removeListener(_fromListener!);
        } catch (e) {
          debugPrint('Error removing from listener: $e');
        }
      }

      // Update the fromController with the selected suggestion
      try {
        fromController.text = placeDescription;
      } catch (e) {
        debugPrint('Error updating fromController text: $e');
        return;
      }

      // Re-add listener
      if (_fromListener != null) {
        try {
          fromController.addListener(_fromListener!);
        } catch (e) {
          debugPrint('Error re-adding from listener: $e');
        }
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
              addToSearchHistory(fromController.text, distance);
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
      final newHistory = AddNewDropLocationSearchHistoryItem(
        location: destination,
        distance: distance,
      );

      final updatedHistory = List<AddNewDropLocationSearchHistoryItem>.from(
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
        '&language=en',
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
    if (_isDisposed) return;

    try {
      // Clear suggestions immediately to improve UI responsiveness
      uiState.value = currentUiState.copyWith(originSuggestions: []);

      // Remove listener temporarily
      if (_destinationListener != null) {
        try {
          destinationController.removeListener(_destinationListener!);
        } catch (e) {
          debugPrint('Error removing destination listener: $e');
        }
      }

      // Update the destinationController with the selected suggestion
      try {
        destinationController.text = placeDescription;
      } catch (e) {
        debugPrint('Error updating destinationController text: $e');
        return;
      }

      // Re-add listener
      if (_destinationListener != null) {
        try {
          destinationController.addListener(_destinationListener!);
        } catch (e) {
          debugPrint('Error re-adding destination listener: $e');
        }
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

      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => switch (currentUiState.serviceType) {
                ServiceType.cabwireShare => RideShareCarTypeScreen(),
                ServiceType.carBooking => ChooseCarTypeScreen(
                  serviceId: currentUiState.serviceId!,
                  pickupLocation: currentUiState.selectedPickupLocation!,
                  pickupAddress: currentUiState.pickupAddress!,
                  dropoffLocation: currentUiState.destinationLocation!,
                  dropoffAddress: currentUiState.destinationAddress!,
                ),
                ServiceType.packageDelivery => FindingRidesScreen(
                  rideResponse: currentUiState.rideResponse!,
                ),
                ServiceType.rentalCar => throw UnimplementedError(),
                ServiceType.emergencyCar => throw UnimplementedError(),
                ServiceType.none => ChooseCarTypeScreen(
                  serviceId: currentUiState.serviceId!,
                  pickupLocation: currentUiState.selectedPickupLocation!,
                  pickupAddress: currentUiState.pickupAddress!,
                  dropoffLocation: currentUiState.destinationLocation!,
                  dropoffAddress: currentUiState.destinationAddress!,
                ),
              },
        ),
      );
    } else {
      showMessage(message: 'Please select both pickup and dropoff locations');
    }
  }

  // Package delivery methods

  Future<void> navigateToPackageDelivery(BuildContext context) async {
    final apiService = locate<ApiService>();
    final body = {
      'pickupLocation': {
        'lat': currentUiState.selectedPickupLocation?.latitude,
        'lng': currentUiState.selectedPickupLocation?.longitude,
        'address': currentUiState.pickupAddress,
      },
      'dropoffLocation': {
        'lat': currentUiState.destinationLocation?.latitude,
        'lng': currentUiState.destinationLocation?.longitude,
        'address': currentUiState.destinationAddress,
      },
      'paymentMethod': 'stripe',
    };
    final response = await apiService.post(
      ApiEndPoint.createPackage,
      header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      body: body,
    );

    response.fold(
      (error) {
        showMessage(message: error.message);
      },
      (data) {
        try {
          // Log the exact structure of the response
          appLog('Full API response: ${data.data}');

          // Package delivery API returns a different structure than what RideResponseModel expects
          // We need to create a compatible structure
          final packageData = data.data['data'];

          // Create a wrapped structure to match RideResponseModel's expectations
          final wrappedData = {
            'success': true,
            'message': 'Package created successfully',
            'data': {
              'userId': packageData['userId'],
              'service': 'packageDelivery', // Add default service
              'category': 'package', // Add default category
              'pickupLocation': packageData['pickupLocation'],
              'dropoffLocation': packageData['dropoffLocation'],
              'distance': packageData['distance'],
              'duration': 0, // Package delivery may not have duration
              'fare': packageData['fare'],
              'rideStatus': packageData['packageStatus'] ?? 'requested',
              'paymentMethod': packageData['paymentMethod'],
              'paymentStatus': packageData['paymentStatus'],
              'rideType': 'package',
              '_id': packageData['_id'],
              'createdAt': packageData['createdAt'],
              'updatedAt': packageData['updatedAt'],
            },
          };

          appLog('Wrapped data for RideResponseModel: $wrappedData');

          // Now pass the properly structured data to RideResponseModel
          uiState.value = currentUiState.copyWith(
            rideResponse: RideResponseModel.fromJson(wrappedData),
          );

          showMessage(message: 'Package created successfully');

          // Navigate to the next screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => FindingRidesScreen(
                    rideResponse: currentUiState.rideResponse!,
                  ),
            ),
          );
        } catch (e) {
          appLog('Error parsing ride response: $e');
          appLog('Error stack trace: ${StackTrace.current}');
          showMessage(message: 'Error processing ride data');
        }
      },
    );
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
    if (_isDisposed) return;

    // Remove listener temporarily
    if (_destinationListener != null) {
      try {
        destinationController.removeListener(_destinationListener!);
      } catch (e) {
        debugPrint('Error removing destination listener: $e');
      }
    }

    // Clear destination text
    try {
      destinationController.clear();
    } catch (e) {
      debugPrint('Error clearing destination controller: $e');
      return;
    }

    // Re-add listener
    if (_destinationListener != null) {
      try {
        destinationController.addListener(_destinationListener!);
      } catch (e) {
        debugPrint('Error re-adding destination listener: $e');
      }
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

  Future<void> confirmStoppage({
    required BuildContext context,
    required String? rideId,
  }) async {
    if (rideId == null || rideId.isEmpty) {
      showMessage(message: 'Ride not found');
      return;
    }

    if (currentUiState.destinationLocation == null ||
        currentUiState.destinationAddress == null) {
      showMessage(message: 'Please select a dropoff location');
      return;
    }

    try {
      toggleLoading(loading: true);

      // Estimate numeric distance in km from routeDistance text like "12.3 km"
      double? totalDistanceKm;
      final distanceText = currentUiState.routeDistance; // e.g., "12.3 km"
      if (distanceText != null) {
        final match = RegExp(r"[0-9]+(\.[0-9]+)?").firstMatch(distanceText);
        final numeric = match?.group(0);
        if (numeric != null) {
          totalDistanceKm = double.tryParse(numeric);
        }
      }

      // Fallback: compute haversine distance between pickup and new drop
      if (totalDistanceKm == null &&
          currentUiState.selectedPickupLocation != null &&
          currentUiState.destinationLocation != null) {
        totalDistanceKm = _computeDistanceKm(
          currentUiState.selectedPickupLocation!,
          currentUiState.destinationLocation!,
        );
      }

      final body = {
        'dropoffLocation': {
          'lat': currentUiState.destinationLocation!.latitude,
          'lng': currentUiState.destinationLocation!.longitude,
          'address': currentUiState.destinationAddress,
        },
        if (totalDistanceKm != null) 'distance': totalDistanceKm,
      };

      final apiService = locate<ApiService>();
      final response = await apiService.patch(
        ApiEndPoint.addStoppage + rideId,
        body: body,
        header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      );

      toggleLoading(loading: false);

      response.fold((error) => showMessage(message: error.message), (success) {
        try {
          showMessage(message: success.message ?? 'Ride updated successfully');
          // Close overlays and then pop this page on the next frame
          try {
            if (Get.isSnackbarOpen) Get.closeAllSnackbars();
          } catch (_) {}
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              Get.back(closeOverlays: true);
            } catch (_) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }
          });
        } catch (e) {
          showMessage(message: 'Failed to parse ride update');
        }
      });
    } catch (e) {
      toggleLoading(loading: false);
      showMessage(message: e.toString());
    }
  }

  double _computeDistanceKm(LatLng a, LatLng b) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degToRad(b.latitude - a.latitude);
    final double dLng = _degToRad(b.longitude - a.longitude);
    final double lat1 = _degToRad(a.latitude);
    final double lat2 = _degToRad(b.latitude);

    final double sinDLat = math.sin(dLat / 2);
    final double sinDLng = math.sin(dLng / 2);
    final double aHarv =
        sinDLat * sinDLat + math.cos(lat1) * math.cos(lat2) * sinDLng * sinDLng;
    final double c = 2 * math.atan2(math.sqrt(aHarv), math.sqrt(1 - aHarv));
    final double distance = earthRadiusKm * c;
    return double.parse(distance.toStringAsFixed(2));
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  void selectHistoryItem(AddNewDropLocationSearchHistoryItem item) {
    if (_isDisposed) return;

    // Fill in the destination controller with the location from history
    if (_destinationListener != null) {
      try {
        destinationController.removeListener(_destinationListener!);
      } catch (e) {
        debugPrint('Error removing destination listener: $e');
      }
    }

    try {
      destinationController.text = item.location;
    } catch (e) {
      debugPrint('Error updating destination controller: $e');
      return;
    }

    if (_destinationListener != null) {
      try {
        destinationController.addListener(_destinationListener!);
      } catch (e) {
        debugPrint('Error re-adding destination listener: $e');
      }
    }

    // Use geocoding to get coordinates for this location
    locationFromAddress(item.location)
        .then((locations) {
          if (locations.isNotEmpty) {
            final location = locations.first;
            final latLng = LatLng(location.latitude, location.longitude);

            // Store as destination
            uiState.value = currentUiState.copyWith(
              originLocation: latLng,
              originAddress: item.location,
            );

            // Calculate route if we have origin/current location
            if (currentUiState.currentLocation != null) {
              calculateRouteDistance(currentUiState.currentLocation!, latLng);
              fetchRoutePolylines(currentUiState.currentLocation!, latLng);
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
    if (_isDisposed) return;

    // Update the pickup location and address in the state
    uiState.value = currentUiState.copyWith(
      selectedPickupLocation: pickupLocation,
      pickupAddress: address,
      currentLocation:
          pickupLocation, // Also set as current location for distance calculation
    );

    // Update the from controller text with the address
    if (_fromListener != null) {
      try {
        fromController.removeListener(_fromListener!);
      } catch (e) {
        debugPrint('Error removing from listener: $e');
      }
    }

    try {
      fromController.text = address;
      appLog('address: $address');
      appLog('pickupLocation: ${pickupLocation.toString()}');
      appLog('fromController.text: ${fromController.text}');
    } catch (e) {
      debugPrint('Error updating from controller: $e');
      return;
    }

    // Re-add the listener
    if (_fromListener != null) {
      try {
        fromController.addListener(_fromListener!);
      } catch (e) {
        debugPrint('Error re-adding from listener: $e');
      }
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
    // Check if we have both origin and destination
    if (currentUiState.selectedPickupLocation == null) {
      showMessage(message: 'Please select a pickup location');
      return;
    }

    if (currentUiState.destinationLocation == null) {
      showMessage(message: 'Please select a dropoff location');
      return;
    }

    // Store current data before reset (needed for navigation)
    final serviceType = currentUiState.serviceType;
    final serviceId = currentUiState.serviceId;
    final pickupLocation = currentUiState.selectedPickupLocation!;
    final pickupAddress = currentUiState.pickupAddress!;
    final dropoffLocation = currentUiState.destinationLocation!;
    final dropoffAddress = currentUiState.destinationAddress!;
    //final rideResponse = currentUiState.rideResponse;

    // Reset state to initial values before navigation
    resetToInitialState();

    // Navigate based on service type
    if (serviceType == ServiceType.packageDelivery) {
      // For package delivery, we need to recreate the API call since we reset the state
      _navigateToPackageDeliveryWithData(
        context,
        pickupLocation,
        pickupAddress,
        dropoffLocation,
        dropoffAddress,
      );
    } else {
      _navigateToCarTypeSelectionWithData(
        context,
        serviceType,
        serviceId!,
        pickupLocation,
        pickupAddress,
        dropoffLocation,
        dropoffAddress,
        nextScreen,
      );
    }
  }

  /// Navigate to car type selection with stored data after reset
  void _navigateToCarTypeSelectionWithData(
    BuildContext context,
    ServiceType serviceType,
    String serviceId,
    LatLng pickupLocation,
    String pickupAddress,
    LatLng dropoffLocation,
    String dropoffAddress,
    Widget? nextScreen,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => switch (serviceType) {
              ServiceType.cabwireShare => RideShareCarTypeScreen(),
              ServiceType.carBooking => ChooseCarTypeScreen(
                serviceId: serviceId,
                pickupLocation: pickupLocation,
                pickupAddress: pickupAddress,
                dropoffLocation: dropoffLocation,
                dropoffAddress: dropoffAddress,
              ),
              // ServiceType.rentalCar => throw UnimplementedError(),
              // ServiceType.emergencyCar => throw UnimplementedError(),
              ServiceType.none => ChooseCarTypeScreen(
                serviceId: serviceId,
                pickupLocation: pickupLocation,
                pickupAddress: pickupAddress,
                dropoffLocation: dropoffLocation,
                dropoffAddress: dropoffAddress,
              ),
              _ => ChooseCarTypeScreen(
                serviceId: serviceId,
                pickupLocation: pickupLocation,
                pickupAddress: pickupAddress,
                dropoffLocation: dropoffLocation,
                dropoffAddress: dropoffAddress,
              ),
            },
      ),
    );
  }

  /// Navigate to package delivery with stored data after reset
  Future<void> _navigateToPackageDeliveryWithData(
    BuildContext context,
    LatLng pickupLocation,
    String pickupAddress,
    LatLng dropoffLocation,
    String dropoffAddress,
  ) async {
    final apiService = locate<ApiService>();
    final body = {
      'pickupLocation': {
        'lat': pickupLocation.latitude,
        'lng': pickupLocation.longitude,
        'address': pickupAddress,
      },
      'dropoffLocation': {
        'lat': dropoffLocation.latitude,
        'lng': dropoffLocation.longitude,
        'address': dropoffAddress,
      },
      'paymentMethod': 'stripe',
    };

    final response = await apiService.post(
      ApiEndPoint.createPackage,
      header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      body: body,
    );

    response.fold(
      (error) {
        showMessage(message: error.message);
      },
      (data) {
        try {
          final packageData = data.data['data'];
          final wrappedData = {
            'success': true,
            'message': 'Package created successfully',
            'data': {
              'userId': packageData['userId'],
              'service': 'packageDelivery',
              'category': 'package',
              'pickupLocation': packageData['pickupLocation'],
              'dropoffLocation': packageData['dropoffLocation'],
              'distance': packageData['distance'],
              'duration': 0,
              'fare': packageData['fare'],
              'rideStatus': packageData['packageStatus'] ?? 'requested',
              'paymentMethod': packageData['paymentMethod'],
              'paymentStatus': packageData['paymentStatus'],
              'rideType': 'package',
              '_id': packageData['_id'],
              'createdAt': packageData['createdAt'],
              'updatedAt': packageData['updatedAt'],
            },
          };

          final rideResponse = RideResponseModel.fromJson(wrappedData);
          showMessage(message: 'Package created successfully');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => FindingRidesScreen(rideResponse: rideResponse),
            ),
          );
        } catch (e) {
          appLog('Error parsing ride response: $e');
          showMessage(message: 'Error processing ride data');
        }
      },
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
