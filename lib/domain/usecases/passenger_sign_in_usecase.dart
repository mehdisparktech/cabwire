import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_auth_repository.dart';

class PassengerSignInUsecase {
  final PassengerAuthRepository repository;

  PassengerSignInUsecase(this.repository);

  Future<Result<SigninResponseEntity>> execute(String email, String password) {
    return repository.signIn(email, password);
  }
}
