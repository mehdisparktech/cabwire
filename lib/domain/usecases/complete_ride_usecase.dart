import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/ride_repository.dart';

/// Parameters for the CompleteRideUseCase
class CompleteRideParams {
  final String rideId;
  final int otp;

  CompleteRideParams({required this.rideId, required this.otp});
}

/// Use case for completing a ride
class CompleteRideUseCase {
  final RideRepository _repository;

  CompleteRideUseCase(this._repository);

  /// Executes the use case to complete a ride
  ///
  /// Takes [CompleteRideParams] containing the rideId and OTP
  /// Returns a [Result<void>] indicating success or failure
  Future<Result<void>> call(CompleteRideParams params) async {
    return await _repository.completeRide(params.rideId, params.otp);
  }
}
