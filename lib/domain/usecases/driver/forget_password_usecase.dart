import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class ForgetPasswordUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  ForgetPasswordUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute(String email) async {
    return repository.forgotPassword(email);
  }
}
