import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/entities/ride/ride_history_entity.dart';
import 'package:cabwire/domain/repositories/ride_history_repository.dart';

class GetRideHistoryUseCase extends BaseUseCase<List<RideHistoryEntity>> {
  final RideHistoryRepository _repository;

  GetRideHistoryUseCase(super.errorMessageHandler, this._repository);

  Future<Either<String, List<RideHistoryEntity>>> execute() async {
    return await mapResultToEither(() async {
      final result = await _repository.getRideHistory();
      return result.fold((error) => throw Exception(error), (data) => data);
    });
  }
}
