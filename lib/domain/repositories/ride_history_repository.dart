import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/entities/ride/ride_history_entity.dart';

abstract class RideHistoryRepository {
  Future<Either<String, List<RideHistoryEntity>>> getRideHistory();
}
