import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class VerifyEmailUsecase extends BaseUseCase<void> {
  final DriverAuthRepository repository;

  VerifyEmailUsecase(super.errorMessageHandler, this.repository);

  Future<Result<Map<String, dynamic>>> execute(String email, String otp) async {
    return repository.verifyEmail(email, otp);
  }
}
