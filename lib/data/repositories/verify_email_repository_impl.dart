import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/verify_email_remote_data_source.dart';
import 'package:cabwire/data/mappers/verify_email_mapper.dart';
import 'package:cabwire/domain/entities/passenger/verify_email_entity.dart';
import 'package:cabwire/domain/repositories/verify_email_repository.dart';
import 'package:fpdart/fpdart.dart' show left, right;

class VerifyEmailRepositoryImpl implements VerifyEmailRepository {
  final VerifyEmailRemoteDataSource _verifyEmailRemoteDataSource;

  VerifyEmailRepositoryImpl(this._verifyEmailRemoteDataSource);

  @override
  Future<Result<VerifyEmailEntity>> verifyEmail(
    String email,
    int oneTimeCode,
  ) async {
    final result = await _verifyEmailRemoteDataSource.verifyEmail(
      email,
      oneTimeCode,
    );
    return result.fold(
      (l) => left(l),
      (r) => right(VerifyEmailMapper.toEntity(r)),
    );
  }
}
