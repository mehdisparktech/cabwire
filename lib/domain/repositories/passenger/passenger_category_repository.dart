import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class PassengerCategoryRepository {
  Future<Either<ApiFailure, List<PassengerCategoryEntity>>>
  getPassengerCategories();
}
