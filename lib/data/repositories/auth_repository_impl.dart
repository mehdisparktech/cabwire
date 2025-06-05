import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver_auth_remote_data_source.dart';
import 'package:cabwire/data/mappers/signin_response_mapper.dart';
import 'package:cabwire/data/mappers/signup_response_mapper.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';
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
  Future<Result<SigninResponseEntity>> signIn(UserModel user) async {
    final result = await _authDataSource.signIn(user);
    return result.fold((l) => left(l), (r) => right(r.toEntity()));
  }

  @override
  Future<Result<String>> verifyEmail(String email, String otp) async {
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
}
