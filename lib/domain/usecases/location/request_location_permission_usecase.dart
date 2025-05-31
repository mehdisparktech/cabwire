import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';
import 'package:cabwire/domain/service/error_message_handler.dart';

class RequestLocationPermissionUsecase extends BaseUseCase<bool> {
  final LocationRepository _locationRepository;

  RequestLocationPermissionUsecase(
    this._locationRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<bool> execute() async {
    return getRight(() => _locationRepository.requestLocationPermission());
  }
}
