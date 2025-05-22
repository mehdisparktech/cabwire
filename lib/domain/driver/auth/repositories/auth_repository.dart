import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/driver/auth/models/auth_user.dart';

abstract class DriverAuthRepository {
  /// Logs in a driver with email and password
  Future<Either<String, AuthUser>> login({
    required String email,
    required String password,
  });

  /// Registers a new driver
  Future<Either<String, AuthUser>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  /// Sends password reset email
  Future<Either<String, String>> forgotPassword({required String email});

  /// Resets password with a token
  Future<Either<String, String>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Logs out the current driver
  Future<Either<String, String>> logout();

  /// Checks if user is currently logged in
  Future<Either<String, bool>> isLoggedIn();

  /// Gets the current authenticated user
  Future<Either<String, AuthUser>> getCurrentUser();
}
