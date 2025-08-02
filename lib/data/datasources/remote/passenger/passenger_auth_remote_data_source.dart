import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/models/signin_response_model.dart';
import 'package:cabwire/data/models/signup_response_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:fpdart/fpdart.dart';

abstract class PassengerAuthRemoteDataSource {
  Future<Result<SignupResponseModel>> signUp(UserModel user);
  Future<Result<SigninResponseModel>> signIn(String email, String password);
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

class PassengerAuthRemoteDataSourceImpl extends PassengerAuthRemoteDataSource {
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
  Future<Result<SigninResponseModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.signIn,
        body: {'email': email, 'password': password},
      );
      appLog("signIn result: ${result.fold((l) => l.message, (r) => r.data)}");
      return result.fold(
        (l) => left(l.message),
        (r) => right(SigninResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      appLog("signIn error: ${e.toString()}");
      return left(e.toString());
    }
  }

  // Verify Email
  @override
  Future<Result<Map<String, dynamic>>> verifyEmail(
    String email,
    String otp,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.verifyEmail,
        body: {'email': email, 'oneTimeCode': int.parse(otp)},
      );
      return result.fold((l) => left(l.message), (r) => right(r.data));
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

  // update driver profile
  @override
  Future<Result<String>> updatePassengerProfileWithEmail(
    ProfileModel profile,
    String email,
  ) async {
    try {
      final result = await apiService.patch(
        ApiEndPoint.updateProfileByEmail + email,
        body: profile.toJson(),
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // update passenger profile
  @override
  Future<Result<String>> updatePassengerProfile(
    String? name,
    String? contact,
    String? profileImage,
  ) async {
    try {
      final result = await apiService.patch(
        ApiEndPoint.updatePassengerProfile + LocalStorage.myEmail,
        body: {'name': name, 'contact': contact},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // reset password with token
  @override
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.resetPasswordWithToken,
        header: {'Authorization': token, 'Content-Type': 'application/json'},
        body: {'newPassword': newpassword, 'confirmPassword': confirmPassword},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // get passenger profile
  @override
  Future<Result<ProfileResponseModel>> getPassengerProfile(String token) async {
    try {
      final result = await apiService.get(
        ApiEndPoint.getProfile,
        header: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(ProfileResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // delete my account
  @override
  Future<Result<String>> deleteMyAccount(String token, String password) async {
    try {
      final result = await apiService.delete(
        ApiEndPoint.deleteMyAccount,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: {'password': password},
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
