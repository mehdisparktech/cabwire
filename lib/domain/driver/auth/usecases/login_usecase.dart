import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/driver/auth/models/auth_user.dart';
import 'package:cabwire/domain/driver/auth/repositories/auth_repository.dart';

class LoginUseCase {
  final DriverAuthRepository repository;

  LoginUseCase(this.repository);

  /// Executes the login use case
  ///
  /// Returns an [Either] with an error message on the left side
  /// or an [AuthUser] on successful login
  Future<Either<String, AuthUser>> execute({
    required String email,
    required String password,
  }) async {
    // Input validation
    if (email.isEmpty) {
      return left('Email cannot be empty');
    }

    if (password.isEmpty) {
      return left('Password cannot be empty');
    }

    if (!email.contains('@')) {
      return left('Please enter a valid email address');
    }

    if (password.length < 6) {
      return left('Password must be at least 6 characters');
    }

    // Pass to repository for API communication
    return repository.login(email: email, password: password);
  }
}
