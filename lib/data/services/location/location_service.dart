import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cabwire/data/models/location_model.dart';

class LocationService {
  LocationService() {
    _initialize();
  }

  /// Stream controller for location updates
  final StreamController<LocationModel> _locationController =
      StreamController<LocationModel>.broadcast();

  /// Stream for location updates
  Stream<LocationModel> get locationStream => _locationController.stream;

  /// Flag to track if a permission request is in progress
  bool _isRequestingPermission = false;

  /// Initialize the location service
  Future<void> _initialize() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, try to request
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        return;
      }
    }
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request location permission from the user
  Future<bool> requestLocationPermission() async {
    try {
      // Check if a request is already in progress
      if (_isRequestingPermission) {
        debugPrint('A permission request is already in progress');
        return false;
      }

      _isRequestingPermission = true;
      final status = await Permission.location.request();
      _isRequestingPermission = false;
      return status.isGranted;
    } catch (e) {
      _isRequestingPermission = false;
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  /// Get the current position of the user
  Future<LocationModel> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, try to request
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled');
        }
      }

      // Check permission
      final hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        final permissionGranted = await requestLocationPermission();
        if (!permissionGranted) {
          throw Exception('Location permission denied');
        }
      }

      // Get the current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed, // Include speed data from Position
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      rethrow;
    }
  }

  /// Start location updates
  void startLocationUpdates() async {
    if (!await hasLocationPermission()) {
      final granted = await requestLocationPermission();
      if (!granted) {
        return;
      }
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        final locationModel = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed, // Include speed data from Position
        );
        _locationController.add(locationModel);
      },
      onError: (e) {
        debugPrint('Error in location stream: $e');
      },
    );
  }

  /// Stop location updates
  Future<void> stopLocationUpdates() async {
    if (!_locationController.isClosed) {
      await _locationController.close();
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await stopLocationUpdates();
  }
}
