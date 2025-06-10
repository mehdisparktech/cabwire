import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';

abstract class DriverAuthRepository {
  Future<Result<SignupResponseEntity>> signUp(UserModel user);
  Future<Result<SigninResponseEntity>> signIn(String email, String password);
  Future<Result<String>> verifyEmail(String email, String otp);
  Future<Result<String>> resetCode(String email);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> updateDriverProfile(DriverProfileModel profile);
}
