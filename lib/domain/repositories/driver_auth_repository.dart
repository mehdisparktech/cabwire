import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';

abstract class DriverAuthRepository {
  Future<Result<SignupResponseEntity>> signUp(UserModel user);
}
