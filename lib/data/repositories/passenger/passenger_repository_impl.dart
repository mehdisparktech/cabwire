import 'package:fpdart/fpdart.dart';
import 'package:cabwire/data/datasources/remote/passenger/passenger_remote_data_source.dart';
import 'package:cabwire/data/models/passenger/create_passenger_model.dart';
import 'package:cabwire/domain/repositories/passenger/passenger_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';

class PassengerRepositoryImpl implements PassengerRepository {
  final PassengerRemoteDataSource _remoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  PassengerRepositoryImpl(this._remoteDataSource, this._errorMessageHandler);

  @override
  Future<Either<String, void>> createPassenger({
    required String name,
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      final model = CreatePassengerModel(
        name: name,
        role: role,
        email: email,
        password: password,
      );

      await _remoteDataSource.createPassenger(model);
      return const Right(null);
    } catch (e) {
      return Left(_errorMessageHandler.generateErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> updateProfilePhoto(
    String email,
    String photo,
  ) async {
    try {
      final result = await _remoteDataSource.updateProfilePhoto(email, photo);
      return result;
    } catch (e) {
      return Left(_errorMessageHandler.generateErrorMessage(e));
    }
  }
}
