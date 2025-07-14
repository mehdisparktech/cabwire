import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/passenger/create_passenger_model.dart';
import 'package:cabwire/data/models/passenger/passenger_response_model.dart';
import 'package:cabwire/domain/services/api_service.dart';

abstract class PassengerRemoteDataSource {
  /// Creates a new passenger
  ///
  /// Throws an [Exception] if an error occurs
  Future<PassengerResponseModel> createPassenger(CreatePassengerModel model);
}

class PassengerRemoteDataSourceImpl implements PassengerRemoteDataSource {
  final ApiService _apiService;

  PassengerRemoteDataSourceImpl(this._apiService);

  @override
  Future<PassengerResponseModel> createPassenger(
    CreatePassengerModel model,
  ) async {
    final response = await _apiService.post(
      ApiEndPoint.passengers,
      body: model.toJson(),
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (success) => PassengerResponseModel.fromJson(success.data),
    );
  }
}
