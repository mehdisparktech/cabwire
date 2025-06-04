import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver_auth_remote_data_source.dart';
import 'package:cabwire/data/mappers/driver_mapper.dart';
import 'package:cabwire/domain/entities/driver/driver_entity.dart';
import 'package:cabwire/domain/repositories/driver_auth_repository.dart';
import 'package:fpdart/fpdart.dart' show left, right;

class DriverAuthRepositoryImpl implements DriverAuthRepository {
  final DriverAuthRemoteDataSource _authDataSource;

  DriverAuthRepositoryImpl(this._authDataSource);

  @override
  Future<Result<DriverEntity>> signUp(DriverEntity driver) async {
    final model = driver.toModel();
    final result = await _authDataSource.signUp(model);
    return result.fold((l) => left(l), (r) => right(r.toEntity()));
  }
}
