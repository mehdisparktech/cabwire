import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';

abstract class PassengerAuthRepository {
  Future<Result<SignupResponseEntity>> signUp(UserModel user);
  Future<Result<SigninResponseEntity>> signIn(String email, String password);
  Future<Result<Map<String, dynamic>>> verifyEmail(String email, String otp);
  Future<Result<String>> resetCode(String email);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> updatePassengerProfileWithEmail(
    ProfileModel profile,
    String email,
  );
  Future<Result<String>> updatePassengerProfile(
    String? name,
    String? contact,
    String? profileImage,
  );
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  );
  Future<Result<ProfileResponseModel>> getPassengerProfile(String token);
  Future<Result<String>> deleteMyAccount(String token, String password);
}
