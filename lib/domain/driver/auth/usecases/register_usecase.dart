import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/driver/auth/models/auth_user.dart';
import 'package:cabwire/domain/driver/auth/models/driver_registration.dart';
import 'package:cabwire/domain/driver/auth/repositories/auth_repository.dart';

class RegisterUseCase {
  final DriverAuthRepository repository;

  RegisterUseCase(this.repository);

  /// Executes the registration use case
  ///
  /// Returns an [Either] with an error message on the left side
  /// or an [AuthUser] on successful registration
  Future<Either<String, AuthUser>> execute({
    required DriverRegistration registration,
  }) async {
    // Basic validation
    if (registration.name.isEmpty) {
      return left('Name cannot be empty');
    }

    if (registration.email.isEmpty) {
      return left('Email cannot be empty');
    }

    if (!registration.email.contains('@')) {
      return left('Please enter a valid email address');
    }

    if (registration.password.isEmpty) {
      return left('Password cannot be empty');
    }

    if (registration.password.length < 6) {
      return left('Password must be at least 6 characters');
    }

    // Call repository for registration
    return repository.register(
      email: registration.email,
      password: registration.password,
      name: registration.name,
      phone: registration.phone ?? '',
    );
  }
}
