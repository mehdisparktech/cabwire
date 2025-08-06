import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_all_remote_data_source.dart';
import 'package:cabwire/data/models/update_status_request_model.dart';
import 'package:cabwire/domain/repositories/driver/driver_repository.dart';
import 'package:fpdart/fpdart.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverAllRemoteDataSource _remoteDataSource;

  DriverRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void>> updateOnlineStatus(String email, bool isOnline) async {
    try {
      final request = UpdateStatusRequestModel(isOnline: isOnline);
      final result = await _remoteDataSource.updateOnlineStatus(email, request);

      return result.fold((error) => left(error), (success) => right(success));
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Result<void>> updateProfilePhoto(String email, String photo) async {
    try {
      final result = await _remoteDataSource.updateProfilePhoto(email, photo);

      return result.fold((error) => left(error), (success) => right(success));
    } catch (e) {
      return left(e.toString());
    }
  }
}
