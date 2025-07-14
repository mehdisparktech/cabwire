import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/services/api/api_success.dart';
import 'package:cabwire/domain/entities/driver/payment_list_entity.dart';
import 'package:cabwire/domain/repositories/driver/driver_earnings_repository.dart';

class GetDriverEarningsUseCase {
  final DriverEarningsRepository _repository;

  GetDriverEarningsUseCase(this._repository);

  Future<Result<ApiSuccess<PaymentListEntity>>> execute() async {
    return await _repository.getDriverEarnings();
  }
}
