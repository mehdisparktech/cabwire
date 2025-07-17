import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/ride/ride_history_response_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';

abstract class RideHistoryRemoteDataSource {
  Future<RideHistoryResponseModel> getRideHistory();
}

class RideHistoryRemoteDataSourceImpl implements RideHistoryRemoteDataSource {
  final ApiService _apiService;

  RideHistoryRemoteDataSourceImpl(this._apiService);

  @override
  Future<RideHistoryResponseModel> getRideHistory() async {
    final userId = LocalStorage.userId;
    final response = await _apiService.get(
      ApiEndPoint.rideHistory + userId,
      header: {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      },
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (success) => RideHistoryResponseModel.fromJson(success.data),
    );
  }
}
