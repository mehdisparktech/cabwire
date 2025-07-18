import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/passenger/passenger_auth_remote_data_source.dart';
import 'package:cabwire/data/mappers/signin_response_mapper.dart';
import 'package:cabwire/data/mappers/signup_response_mapper.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_auth_repository.dart';
import 'package:fpdart/fpdart.dart' show left, right;

class PassengerAuthRepositoryImpl implements PassengerAuthRepository {
  final PassengerAuthRemoteDataSource _authDataSource;

  PassengerAuthRepositoryImpl(this._authDataSource);

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
      final profileResult = await _authDataSource.getPassengerProfile(
        'Bearer ${result.fold((l) => l, (r) => r.data?.token ?? '')}',
      );
      if (profileResult.isRight()) {
        final profileData = profileResult.fold((l) => l, (r) => r.data);
        if (profileData != null) {
          final profileModel = profileData as ProfileModel;
          await LocalStorage.savePassengerProfile(profileModel);
        } else {
          await LocalStorage.removePassengerProfile();
        }
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
  Future<Result<String>> updatePassengerProfileWithEmail(
    ProfileModel profile,
    String email,
  ) async {
    final result = await _authDataSource.updatePassengerProfileWithEmail(
      profile,
      email,
    );
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> updatePassengerProfile(
    String? name,
    String? contact,
    String? profileImage,
  ) async {
    final result = await _authDataSource.updatePassengerProfile(
      name,
      contact,
      profileImage,
    );
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

  @override
  Future<Result<ProfileResponseModel>> getPassengerProfile(String token) async {
    final result = await _authDataSource.getPassengerProfile(token);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> deleteMyAccount(String token, String password) async {
    final result = await _authDataSource.deleteMyAccount(token, password);
    return result.fold((l) => left(l), (r) => right(r));
  }
}
