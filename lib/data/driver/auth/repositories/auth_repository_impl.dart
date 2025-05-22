import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/driver/auth/models/auth_user.dart';
import 'package:cabwire/domain/driver/auth/repositories/auth_repository.dart';

/// Implementation of the [DriverAuthRepository] interface
///
/// Currently uses mock data but is structured for easy API integration
class DriverAuthRepositoryImpl implements DriverAuthRepository {
  // Mock current user for development
  AuthUser? _currentUser;

  @override
  Future<Either<String, AuthUser>> login({
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
        _currentUser = AuthUser(
          id: '1',
          email: email,
          name: 'Mehdi',
          phone: '+1234567890',
          isVerified: true,
        );
        return right(_currentUser!);
      }

      return left('Invalid email or password');
    } catch (e) {
      return left('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, AuthUser>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock implementation - replace with actual API call
      _currentUser = AuthUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        phone: phone,
        isVerified: false,
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
  Future<Either<String, AuthUser>> getCurrentUser() async {
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
