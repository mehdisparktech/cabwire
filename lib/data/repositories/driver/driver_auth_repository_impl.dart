import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_auth_remote_data_source.dart';
import 'package:cabwire/data/mappers/signin_response_mapper.dart';
import 'package:cabwire/data/mappers/signup_response_mapper.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';
import 'package:fpdart/fpdart.dart' show left, right;

class DriverAuthRepositoryImpl implements DriverAuthRepository {
  final DriverAuthRemoteDataSource _authDataSource;

  DriverAuthRepositoryImpl(this._authDataSource);

  @override
  Future<Result<SignupResponseEntity>> signUp(UserModel user) async {
    final result = await _authDataSource.signUp(user);
    return result.fold((l) => left(l), (r) => right(r.toEntity()));
  }

  @override
  Future<Result<SigninResponseEntity>> signIn(
    String email,
    String password,
  ) async {
    final result = await _authDataSource.signIn(email, password);
    if (result.isRight()) {
      final profileResult = await _authDataSource.getDriverProfile(
        'Bearer ${result.fold((l) => l, (r) => r.data?.token ?? '')}',
      );
      if (profileResult.isRight()) {
        final profileData = profileResult.fold((l) => l, (r) => r);
        final profileModel = profileData as DriverProfileModel;
        await LocalStorage.saveDriverProfile(profileModel);
      }
      return result.fold((l) => left(l), (r) => right(r.toEntity()));
    }
    return result.fold((l) => left(l), (r) => right(r.toEntity()));
  }

  @override
  Future<Result<Map<String, dynamic>>> verifyEmail(
    String email,
    String otp,
  ) async {
    final result = await _authDataSource.verifyEmail(email, otp);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> resetCode(String email) async {
    final result = await _authDataSource.resetCode(email);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> forgotPassword(String email) async {
    final result = await _authDataSource.forgotPassword(email);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> updateDriverProfile(
    DriverProfileModel profile,
    String email,
  ) async {
    final result = await _authDataSource.updateDriverProfile(profile, email);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  ) async {
    final result = await _authDataSource.resetPasswordWithToken(
      token,
      newpassword,
      confirmPassword,
    );
    return result.fold((l) => left(l), (r) => right(r));
  }
}
