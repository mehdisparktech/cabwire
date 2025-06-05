import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class ResentCodeUsecase extends BaseUseCase<String> {
  final DriverAuthRepository repository;

  ResentCodeUsecase(super.errorMessageHandler, this.repository);

  Future<Result<String>> execute(String email) async {
    return repository.resetCode(email);
  }
}
