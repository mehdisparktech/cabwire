import 'package:cabwire/domain/entities/driver/driver_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/entities/driver/driver_registration_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class RegisterUseCase {
  final DriverAuthRepository repository;

  RegisterUseCase(this.repository);

  /// Executes the registration use case
  ///
  /// Returns an [Either] with an error message on the left side
  /// or an [AuthUser] on successful registration
  Future<Either<String, DriverRegistrationEntity>> execute({
    required DriverEntity driver,
  }) async {
    // Basic validation
    if (driver.name == null || driver.name!.isEmpty) {
      return left('Name cannot be empty');
    }

    if (driver.email == null || driver.email!.isEmpty) {
      return left('Email cannot be empty');
    }

    if (driver.email == null || !driver.email!.contains('@')) {
      return left('Please enter a valid email address');
    }

    if (driver.password == null || driver.password!.isEmpty) {
      return left('Password cannot be empty');
    }

    if (driver.password == null || driver.password!.length < 6) {
      return left('Password must be at least 6 characters');
    }

    // // Call repository for registration
    // return repository.register(
    //   email: registration.email ?? '',
    //   password: registration.password ?? '',
    //   name: registration.name,

    // );
    return repository.register(driver: driver);
  }
}
