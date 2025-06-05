import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class SignInUsecase {
  final DriverAuthRepository repository;

  SignInUsecase(this.repository);

  Future<Result<SigninResponseEntity>> execute(UserModel user) {
    return repository.signIn(user);
  }
}
