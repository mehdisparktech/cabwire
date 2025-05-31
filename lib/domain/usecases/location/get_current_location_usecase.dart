import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/entities/location_entity.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';
import 'package:cabwire/domain/service/error_message_handler.dart';

class GetCurrentLocationUsecase extends BaseUseCase<LocationEntity> {
  final LocationRepository _locationRepository;

  GetCurrentLocationUsecase(
    this._locationRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, LocationEntity>> execute() async {
    try {
      // First check if we have location permission
      final hasPermission = await _locationRepository.hasLocationPermission();

      if (hasPermission) {
        // If we have permission, get the current location
        return await _locationRepository.getCurrentLocation();
      } else {
        // If we don't have permission, try to request it
        final permissionGranted =
            await _locationRepository.requestLocationPermission();

        if (permissionGranted) {
          // If permission is granted, get the current location
          return await _locationRepository.getCurrentLocation();
        } else {
          // If permission is denied, return the default location
          final defaultLocation =
              await _locationRepository.getDefaultLocation();
          return right(defaultLocation);
        }
      }
    } catch (error) {
      // Map the error to an error message using mapResultToEither
      return await mapResultToEither(() => throw error);
    }
  }
}
