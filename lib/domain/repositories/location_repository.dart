import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/entities/location_entity.dart';

abstract class LocationRepository {
  /// Check if location permission is granted
  Future<bool> hasLocationPermission();

  /// Request location permission from the user
  Future<bool> requestLocationPermission();

  /// Get the current location of the user
  Future<Either<String, LocationEntity>> getCurrentLocation();

  /// Get the location stream that emits location updates
  Stream<Either<String, LocationEntity>> getLocationUpdates();

  /// Get the default location when permission is denied
  Future<LocationEntity> getDefaultLocation();
}
