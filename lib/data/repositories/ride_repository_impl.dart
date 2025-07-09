import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/ride_remote_data_source.dart';
import 'package:cabwire/data/mappers/ride_mapper.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/entities/ride_entity.dart';
import 'package:cabwire/domain/repositories/ride_repository.dart';
import 'package:fpdart/fpdart.dart';

class RideRepositoryImpl implements RideRepository {
  final RideRemoteDataSource _remoteDataSource;

  RideRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void>> createRideRequest(RideEntity ride) async {
    try {
      // Convert entity to model
      final requestModel = RideMapper.toRequestModel(ride);

      // Call the remote data source
      final result = await _remoteDataSource.createRide(requestModel);

      // Return the result, mapping success to void
      return result.fold((error) => left(error), (_) => right(null));
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<RideResponseModel>> completeRide(String rideId, int otp) async {
    try {
      // Call the remote data source
      final result = await _remoteDataSource.completeRide(rideId, otp);

      // Return the result, mapping success to void
      return result.fold((error) => left(error), (success) => right(success));
    } catch (e) {
      return left(e.toString());
    }
  }
}
