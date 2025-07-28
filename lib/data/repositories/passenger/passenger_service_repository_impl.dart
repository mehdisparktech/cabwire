import 'package:cabwire/data/datasources/remote/passenger/passenger_service_remote_data_source.dart';
import 'package:cabwire/data/mappers/passenger_service_mapper.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_service_repository.dart';
import 'package:fpdart/fpdart.dart';

class PassengerServiceRepositoryImpl implements PassengerServiceRepository {
  final PassengerServiceRemoteDataSource _remoteDataSource;

  PassengerServiceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ApiFailure, List<PassengerServiceEntity>>>
  getPassengerServices() async {
    try {
      final response = await _remoteDataSource.getPassengerServices();
      final services = PassengerServiceMapper.fromModelList(response.data);
      return right(services);
    } on ApiFailure catch (e) {
      return left(e);
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }
}
