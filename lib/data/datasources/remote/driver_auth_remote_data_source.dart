import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/driver/driver_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverAuthRemoteDataSource {
  Future<Result<DriverModel>> signUp(DriverModel driver);
}

class DriverAuthRemoteDataSourceImpl extends DriverAuthRemoteDataSource {
  final apiService = ApiServiceImpl.instance;
  @override
  Future<Result<DriverModel>> signUp(DriverModel driver) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.signUp,
        body: driver.toJson(),
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(DriverModel.fromJson(r.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
