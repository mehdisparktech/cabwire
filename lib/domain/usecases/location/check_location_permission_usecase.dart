import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/repositories/location_repository.dart';
import 'package:cabwire/domain/service/error_message_handler.dart';

class CheckLocationPermissionUsecase extends BaseUseCase<bool> {
  final LocationRepository _locationRepository;

  CheckLocationPermissionUsecase(
    this._locationRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<bool> execute() async {
    return getRight(() => _locationRepository.hasLocationPermission());
  }
}
