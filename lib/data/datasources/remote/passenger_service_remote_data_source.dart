import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/passenger/passenger_service_list_response_model.dart';
import 'package:cabwire/domain/services/api_service.dart';

abstract class PassengerServiceRemoteDataSource {
  Future<PassengerServiceListResponseModel> getPassengerServices();
}

class PassengerServiceRemoteDataSourceImpl
    implements PassengerServiceRemoteDataSource {
  final ApiService _apiService;

  PassengerServiceRemoteDataSourceImpl(this._apiService);

  @override
  Future<PassengerServiceListResponseModel> getPassengerServices() async {
    final response = await _apiService.get(ApiEndPoint.passengerServices);

    return response.fold(
      (failure) => throw failure,
      (success) => PassengerServiceListResponseModel.fromJson(success.data),
    );
  }
}
