import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class DriverSignUpUseCase {
  final DriverAuthRepository repository;

  DriverSignUpUseCase(this.repository);

  Future<Result<DriverEntity>> call(DriverEntity driver) {
    return repository.signUp(driver);
  }
}
