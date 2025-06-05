import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/signin_response_model.dart';
import 'package:cabwire/data/models/signup_response_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverAuthRemoteDataSource {
  Future<Result<SignupResponseModel>> signUp(UserModel user);
  Future<Result<SigninResponseModel>> signIn(UserModel user);
  Future<Result<String>> verifyEmail(String email, String otp);
  Future<Result<String>> resetCode(String email);
  Future<Result<String>> forgotPassword(String email);
}

class DriverAuthRemoteDataSourceImpl extends DriverAuthRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  // Sign Up
  @override
  Future<Result<SignupResponseModel>> signUp(UserModel user) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.signUp,
        body: user.toJson(),
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(SignupResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // Sign In
  @override
  Future<Result<SigninResponseModel>> signIn(UserModel user) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.signIn,
        body: user.toJson(),
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(SigninResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // Verify Email
  @override
  Future<Result<String>> verifyEmail(String email, String otp) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.verifyEmail,
        body: {'email': email, 'oneTimeCode': int.parse(otp)},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // reset code
  @override
  Future<Result<String>> resetCode(String email) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.resetCode,
        body: {'email': email},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // forgot password
  @override
  Future<Result<String>> forgotPassword(String email) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.forgotPassword,
        body: {'email': email},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
