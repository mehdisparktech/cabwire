import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';
import 'package:cabwire/domain/repositories/passenger_service_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetPassengerServicesUseCase {
  final PassengerServiceRepository _repository;

  GetPassengerServicesUseCase(this._repository);

  Future<Either<ApiFailure, List<PassengerServiceEntity>>> call() async {
    return await _repository.getPassengerServices();
  }
}
