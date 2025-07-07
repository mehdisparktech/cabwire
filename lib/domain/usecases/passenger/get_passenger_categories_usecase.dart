import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/repositories/passenger_category_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetPassengerCategoriesUseCase {
  final PassengerCategoryRepository _repository;

  GetPassengerCategoriesUseCase(this._repository);

  Future<Either<ApiFailure, List<PassengerCategoryEntity>>> call() async {
    return await _repository.getPassengerCategories();
  }
}

class GetPassengerCategoriesParams {
  const GetPassengerCategoriesParams();
}
