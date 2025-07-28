import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/ride_completed_response_model.dart';
import 'package:cabwire/domain/entities/ride_entity.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';

/// Interface for the Ride repository
abstract class RideRepository {
  /// Creates a new ride request
  ///
  /// Takes a [RideEntity] with all the required ride information
  /// Returns a [Result<RideResponseModel>] indicating success or failure
  Future<Result<RideResponseModel>> createRideRequest(RideEntity ride);

  /// Completes a ride with the provided rideId and OTP
  ///
  /// Takes a [String] rideId and [int] otp for verification
  /// Returns a [Result<void>] indicating success or failure
  Future<Result<RideCompletedResponseModel>> completeRide(
    String rideId,
    int otp,
  );

  /// Cancels a ride with the provided rideId
  ///
  /// Takes a [String] rideId
  /// Returns a [Result<RideResponseModel>] indicating success or failure
  Future<Result<String>> cancelRide(String rideId);
}
