import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/services/api/api_success.dart';
import 'package:cabwire/domain/entities/driver/payment_list_entity.dart';

abstract class DriverEarningsRepository {
  Future<Result<ApiSuccess<PaymentListEntity>>> getDriverEarnings();
}
