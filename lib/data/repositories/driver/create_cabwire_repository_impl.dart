import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver/create_cabwire_remote_data_source.dart';
import 'package:cabwire/data/models/driver/create_cabwire_model.dart';
import 'package:cabwire/domain/entities/driver/create_cabwire_entity.dart';
import 'package:cabwire/domain/repositories/driver/create_cabwire_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateCabwireRepositoryImpl implements CreateCabwireRepository {
  final CreateCabwireRemoteDataSource remoteDataSource;

  CreateCabwireRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<CabwireResponseEntity>> createCabwire(
    CabwireRequestEntity request,
  ) async {
    final requestModel = CabwireRequestModel.fromEntity(request);
    final result = await remoteDataSource.createCabwire(requestModel);

    return result.fold(
      (error) => left(error),
      (response) => right(response.toEntity()),
    );
  }
}
