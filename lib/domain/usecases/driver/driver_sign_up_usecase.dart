import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';

class DriverSignUpUseCase {
  final DriverAuthRepository repository;

  DriverSignUpUseCase(this.repository);

  Future<Result<SignupResponseEntity>> call(UserModel user) {
    return repository.signUp(user);
  }
}
