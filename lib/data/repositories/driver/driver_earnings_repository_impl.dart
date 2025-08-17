import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_earnings_remote_data_source.dart';
import 'package:cabwire/data/mappers/payment_list_mapper.dart';
import 'package:cabwire/data/services/api/api_success.dart';
import 'package:cabwire/domain/entities/driver/payment_list_entity.dart';
import 'package:cabwire/domain/repositories/driver/driver_earnings_repository.dart';
import 'package:cabwire/domain/entities/driver/driver_earnings_entity.dart';
import 'package:fpdart/fpdart.dart';

class DriverEarningsRepositoryImpl implements DriverEarningsRepository {
  final DriverEarningsRemoteDataSource _remoteDataSource;

  DriverEarningsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ApiSuccess<PaymentListEntity>>> getDriverEarnings() async {
    try {
      final result = await _remoteDataSource.getDriverEarnings();

      return result.fold((error) => left(error), (model) {
        final entity = PaymentListMapper.toEntity(model);
        return right(
          ApiSuccess<PaymentListEntity>(
            statusCode: 200,
            data: entity,
            message: model.message,
          ),
        );
      });
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<ApiSuccess<DriverEarningsEntity>>>
  getDriverEarningsNew() async {
    try {
      final totalResult = await _remoteDataSource.getTotalEarnings();
      final dailyResult = await _remoteDataSource.getDailyEarnings();

      return totalResult.fold(
        (error) => left(error),
        (totalModel) => dailyResult.fold((error) => left(error), (dailyModel) {
          final entity = PaymentListMapper.toDriverEarningsEntity(
            total: totalModel,
            daily: dailyModel,
          );
          return right(
            ApiSuccess<DriverEarningsEntity>(
              statusCode: 200,
              data: entity,
              message: 'Earnings fetched',
            ),
          );
        }),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
