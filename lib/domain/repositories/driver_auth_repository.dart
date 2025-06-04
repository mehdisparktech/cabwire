import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart';

abstract class DriverAuthRepository {
  Future<Result<DriverEntity>> signUp(DriverEntity driver);
}
