import 'package:fpdart/fpdart.dart';

abstract class ResetPasswordRepository {
  Future<Either<String, void>> resetPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
