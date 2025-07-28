import 'dart:async';
import 'package:cabwire/data/models/location_model.dart';
import 'package:cabwire/data/services/local_cache_service.dart';
import 'package:cabwire/domain/entities/location_entity.dart';

abstract class LocationLocalDataSource {
  /// Get the default location from local cache or create a new one
  Future<LocationModel> getDefaultLocation();

  /// Save the last known location to local cache
  Future<void> saveLastKnownLocation(LocationModel location);

  /// Get the last known location from local cache
  Future<LocationModel?> getLastKnownLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final LocalCacheService _localCacheService;

  LocationLocalDataSourceImpl(this._localCacheService);

  static const String _lastLocationKey = 'last_location';

  @override
  Future<LocationModel> getDefaultLocation() async {
    final locationData =
        _localCacheService.getData(key: _lastLocationKey)
            as Map<String, dynamic>?;

    if (locationData != null) {
      try {
        return LocationModel.fromJson(locationData);
      } catch (e) {
        // If we can't parse the saved location, return the default one
        return LocationModel.fromEntity(LocationEntity.defaultLocation());
      }
    }

    // If no saved location, return default
    return LocationModel.fromEntity(LocationEntity.defaultLocation());
  }

  @override
  Future<void> saveLastKnownLocation(LocationModel location) async {
    await _localCacheService.saveData(
      key: _lastLocationKey,
      value: location.toJson(),
    );
  }

  @override
  Future<LocationModel?> getLastKnownLocation() async {
    final locationData =
        _localCacheService.getData(key: _lastLocationKey)
            as Map<String, dynamic>?;

    if (locationData != null) {
      try {
        return LocationModel.fromJson(locationData);
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}
