import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/ride/create_ride_request_model.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class RideRemoteDataSource {
  /// Creates a new ride request
  ///
  Future<Result<RideResponseModel>> createRide(CreateRideRequestModel request);
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
}
