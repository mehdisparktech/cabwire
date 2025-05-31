import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/entities/location_entity.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';
import 'package:cabwire/domain/service/error_message_handler.dart';

class GetLocationUpdatesUsecase extends BaseUseCase<LocationEntity> {
  final LocationRepository _locationRepository;

  GetLocationUpdatesUsecase(
    this._locationRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Stream<Either<String, LocationEntity>> execute() {
    return _locationRepository.getLocationUpdates();
  }
}
