import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/ride_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';

class CancelRideUseCase extends BaseUseCase<String> {
  final RideRepository _repository;

  CancelRideUseCase(this._repository, ErrorMessageHandler errorMessageHandler)
    : super(errorMessageHandler);

  Future<Result<String>> execute(String rideId) async {
    return await _repository.cancelRide(rideId);
  }
}
