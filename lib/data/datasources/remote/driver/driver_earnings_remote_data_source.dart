import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/driver/payment_list_response_model.dart';
import 'package:cabwire/data/models/driver/driver_earnings_models.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverEarningsRemoteDataSource {
  Future<Result<PaymentListResponseModel>> getDriverEarnings();
  Future<Result<TotalEarningResponseModel>> getTotalEarnings();
  Future<Result<DailyEarningResponseModel>> getDailyEarnings();
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

  @override
  Future<Result<TotalEarningResponseModel>> getTotalEarnings() async {
    try {
      final response = await apiService.get(
        ApiEndPoint.myTotalEarnings,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
          "Content-Type": "application/json",
        },
      );

      return response.fold(
        (failure) => left(failure.message),
        (success) => right(TotalEarningResponseModel.fromJson(success.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<DailyEarningResponseModel>> getDailyEarnings() async {
    try {
      final response = await apiService.get(
        ApiEndPoint.myDailyEarnings,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
          "Content-Type": "application/json",
        },
      );

      return response.fold(
        (failure) => left(failure.message),
        (success) => right(DailyEarningResponseModel.fromJson(success.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
