import 'package:cabwire/domain/entities/driver/driver_registration_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

/// Implementation of the [DriverAuthRepository] interface
///
/// Currently uses mock data but is structured for easy API integration
class DriverAuthRepositoryImpl implements DriverAuthRepository {
  // Mock current user for development
  DriverRegistrationEntity? _currentUser;

  @override
  Future<Either<String, DriverRegistrationEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // This is where you would connect to your API
      // Replace with actual API implementation

      // Mock implementation for development
      if (email == 'mehdi@gmail.com' && password == '12345678') {
        _currentUser = DriverRegistrationEntity(
          email: email,
          name: 'Mehdi',
          phone: '+1234567890',
          password: password,
        );
        return right(_currentUser!);
      }

      return left('Invalid email or password');
    } catch (e) {
      return left('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, DriverRegistrationEntity>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock implementation - replace with actual API call
      _currentUser = DriverRegistrationEntity(
        email: email,
        name: name,
        phone: phone,
        password: password,
      );

      return right(_currentUser!);
    } catch (e) {
      return left('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> forgotPassword({required String email}) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock implementation - replace with actual API call
      return right('Password reset email sent to $email');
    } catch (e) {
      return left('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, DriverRegistrationEntity>> getCurrentUser() async {
    try {
      if (_currentUser != null) {
        return right(_currentUser!);
      }
      return left('No user logged in');
    } catch (e) {
      return left('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> isLoggedIn() async {
    try {
      // Check if user is logged in
      return right(_currentUser != null);
    } catch (e) {
      return left('Failed to check login status: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear current user
      _currentUser = null;

      return right('Logged out successfully');
    } catch (e) {
      return left('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock implementation - replace with actual API call
      return right('Password reset successfully');
    } catch (e) {
      return left('Failed to reset password: ${e.toString()}');
    }
  }
}
