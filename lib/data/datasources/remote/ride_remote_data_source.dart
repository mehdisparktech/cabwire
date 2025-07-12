import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/ride/complete_ride_model.dart';
import 'package:cabwire/data/models/ride/create_ride_request_model.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/data/models/ride_completed_response_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class RideRemoteDataSource {
  /// Creates a new ride request
  ///
  Future<Result<RideResponseModel>> createRide(CreateRideRequestModel request);

  /// Completes a ride with the provided rideId and OTP
  ///
  Future<Result<RideCompletedResponseModel>> completeRide(
    String rideId,
    int otp,
  );

  /// Cancels a ride with the provided rideId
  ///
  Future<Result<String>> cancelRide(String rideId);
}

class RideRemoteDataSourceImpl implements RideRemoteDataSource {
  final ApiService _apiService;

  RideRemoteDataSourceImpl(this._apiService);

  @override
  Future<Result<RideResponseModel>> createRide(
    CreateRideRequestModel request,
  ) async {
    try {
      final response = await _apiService.post(
        ApiEndPoint.createRide,
        body: request.toJson(),
        header: {
          'Authorization': 'Bearer ${LocalStorage.token}',
          'Content-Type': 'application/json',
        },
      );

      return response.fold(
        (failure) => left(failure.message),
        (success) => right(RideResponseModel.fromJson(success.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<RideCompletedResponseModel>> completeRide(
    String rideId,
    int otp,
  ) async {
    try {
      final request = CompleteRideModel(rideId: rideId, otp: otp);

      final response = await _apiService.post(
        ApiEndPoint.closeTrip + rideId,
        body: request.toJson(),
        header: {
          'Authorization': 'Bearer ${LocalStorage.token}',
          'Content-Type': 'application/json',
        },
      );

      return response.fold(
        (failure) => left(failure.message),
        (success) => right(RideCompletedResponseModel.fromJson(success.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<String>> cancelRide(String rideId) async {
    try {
      final response = await _apiService.patch(
        ApiEndPoint.cancelRide + rideId,
        body: {},
        header: {
          'Authorization': 'Bearer ${LocalStorage.token}',
          'Content-Type': 'application/json',
        },
      );

      return response.fold(
        (failure) => left(failure.message),
        (success) => right(success.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
