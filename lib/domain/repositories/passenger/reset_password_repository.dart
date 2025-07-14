import 'package:cabwire/core/base/result.dart';

abstract class ResetPasswordRepository {
  Future<Result<String>> resetPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
