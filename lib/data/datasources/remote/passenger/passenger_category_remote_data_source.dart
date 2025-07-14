import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/passenger/passenger_category_list_response_model.dart';
import 'package:cabwire/domain/services/api_service.dart';

abstract class PassengerCategoryRemoteDataSource {
  Future<PassengerCategoryListResponseModel> getPassengerCategories();
}

class PassengerCategoryRemoteDataSourceImpl
    implements PassengerCategoryRemoteDataSource {
  final ApiService _apiService;

  PassengerCategoryRemoteDataSourceImpl(this._apiService);

  @override
  Future<PassengerCategoryListResponseModel> getPassengerCategories() async {
    final response = await _apiService.get(ApiEndPoint.passengerCategories);

    return response.fold(
      (failure) => throw failure,
      (success) => PassengerCategoryListResponseModel.fromJson(success.data),
    );
  }
}
