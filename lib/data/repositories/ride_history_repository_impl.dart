import 'package:cabwire/domain/entities/ride/ride_history_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cabwire/data/datasources/remote/ride_history_remote_data_source.dart';
import 'package:cabwire/data/mappers/ride_history_mapper.dart';
import 'package:cabwire/domain/repositories/ride_history_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';

class RideHistoryRepositoryImpl implements RideHistoryRepository {
  final RideHistoryRemoteDataSource _remoteDataSource;
  final RideHistoryMapper _mapper;
  final ErrorMessageHandler _errorMessageHandler;

  RideHistoryRepositoryImpl(
    this._remoteDataSource,
    this._mapper,
    this._errorMessageHandler,
  );

  @override
  Future<Either<String, List<RideHistoryEntity>>> getRideHistory() async {
    try {
      final response = await _remoteDataSource.getRideHistory();

      if (response.success) {
        final entities = _mapper.mapToEntityList(response.data);
        return right(entities);
      } else {
        return left(response.message);
      }
    } catch (e) {
      final errorMessage = _errorMessageHandler.generateErrorMessage(e);
      return left(errorMessage);
    }
  }
}
