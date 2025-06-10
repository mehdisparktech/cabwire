import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class SignInUsecase {
  final DriverAuthRepository repository;

  SignInUsecase(this.repository);

  Future<Result<SigninResponseEntity>> execute(String email, String password) {
    return repository.signIn(email, password);
  }
}
