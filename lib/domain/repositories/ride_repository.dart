import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/ride_entity.dart';

/// Interface for the Ride repository
abstract class RideRepository {
  /// Creates a new ride request
  ///
  /// Takes a [RideEntity] with all the required ride information
  /// Returns a [Result<void>] indicating success or failure
  Future<Result<void>> createRideRequest(RideEntity ride);

  /// Completes a ride with the provided rideId and OTP
  ///
  /// Takes a [String] rideId and [int] otp for verification
  /// Returns a [Result<void>] indicating success or failure
  Future<Result<void>> completeRide(String rideId, int otp);
}
