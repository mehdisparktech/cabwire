import 'package:cabwire/domain/repositories/passenger/reset_password_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResetPasswordParams {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class ResetPasswordUseCase {
  final ResetPasswordRepository _resetPasswordRepository;

  ResetPasswordUseCase(this._resetPasswordRepository);

  Future<Either<String, void>> execute(ResetPasswordParams params) async {
    return await _resetPasswordRepository.resetPassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}
