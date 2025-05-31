import 'package:fpdart/fpdart.dart';
import 'package:cabwire/data/datasources/local/location_local_data_source.dart';
import 'package:cabwire/data/services/location_service.dart';
import 'package:cabwire/domain/entities/location_entity.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';
import 'package:cabwire/domain/service/error_message_handler.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService _locationService;
  final LocationLocalDataSource _locationLocalDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  LocationRepositoryImpl(
    this._locationService,
    this._locationLocalDataSource,
    this._errorMessageHandler,
  );

  @override
  Future<bool> hasLocationPermission() async {
    return await _locationService.hasLocationPermission();
  }

  @override
  Future<bool> requestLocationPermission() async {
    return await _locationService.requestLocationPermission();
  }

  @override
  Future<Either<String, LocationEntity>> getCurrentLocation() async {
    try {
      final locationModel = await _locationService.getCurrentLocation();

      // Save the last known location
      await _locationLocalDataSource.saveLastKnownLocation(locationModel);

      return right(locationModel);
    } catch (error) {
      final errorMessage = _errorMessageHandler.generateErrorMessage(error);
      return left(errorMessage);
    }
  }

  @override
  Stream<Either<String, LocationEntity>> getLocationUpdates() {
    _locationService.startLocationUpdates();

    return _locationService.locationStream
        .map((locationModel) => right<String, LocationEntity>(locationModel))
        .handleError((error) {
          final errorMessage = _errorMessageHandler.generateErrorMessage(error);
          return left<String, LocationEntity>(errorMessage);
        });
  }

  @override
  Future<LocationEntity> getDefaultLocation() async {
    return await _locationLocalDataSource.getDefaultLocation();
  }
}
