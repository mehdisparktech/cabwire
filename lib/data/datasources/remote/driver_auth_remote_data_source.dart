import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/driver/driver_model.dart';
import 'package:cabwire/data/models/driver/driver_registration_model.dart';
import 'package:cabwire/domain/entities/driver/driver_registration_entity.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverAuthRemoteDataSource {
  Future<Either<String, DriverRegistrationEntity>> register(DriverModel driver);
}

class DriverAuthRemoteDataSourceImpl extends DriverAuthRemoteDataSource {
  final apiService = ApiServiceImpl.instance;
  @override
  Future<Either<String, DriverRegistrationEntity>> register(
    DriverModel driver,
  ) async {
    final result = await apiService.post(
      ApiEndPoint.signUp,
      body: driver.toJson(),
    );
    return result.fold(
      (l) => left(l.message),
      (r) => right(DriverRegistrationModel.fromJson(r.data)),
    );
  }
}
