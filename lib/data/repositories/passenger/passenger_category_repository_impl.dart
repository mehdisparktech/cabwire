import 'package:cabwire/data/datasources/remote/passenger/passenger_category_remote_data_source.dart';
import 'package:cabwire/data/mappers/passenger_category_mapper.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_category_repository.dart';
import 'package:fpdart/fpdart.dart';

class PassengerCategoryRepositoryImpl implements PassengerCategoryRepository {
  final PassengerCategoryRemoteDataSource _remoteDataSource;

  PassengerCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ApiFailure, List<PassengerCategoryEntity>>>
  getPassengerCategories() async {
    try {
      final response = await _remoteDataSource.getPassengerCategories();
      final categories = PassengerCategoryMapper.fromModelList(response.data);
      return right(categories);
    } on ApiFailure catch (e) {
      return left(e);
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }
}
