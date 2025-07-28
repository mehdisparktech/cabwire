import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class PassengerServiceRepository {
  Future<Either<ApiFailure, List<PassengerServiceEntity>>>
  getPassengerServices();
}
