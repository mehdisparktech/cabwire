import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/driver/payment_list_response_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverEarningsRemoteDataSource {
  Future<Result<PaymentListResponseModel>> getDriverEarnings();
}

class DriverEarningsRemoteDataSourceImpl
    implements DriverEarningsRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  @override
  Future<Result<PaymentListResponseModel>> getDriverEarnings() async {
    try {
      final response = await apiService.get(
        ApiEndPoint.driverEarnings + LocalStorage.userId,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
          "Content-Type": "application/json",
        },
      );

      return response.fold(
        (failure) => left(failure.message),
        (success) => right(PaymentListResponseModel.fromJson(success.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
