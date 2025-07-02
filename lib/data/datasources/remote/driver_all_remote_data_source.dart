import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/update_status_request_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverAllRemoteDataSource {
  Future<Result<void>> updateOnlineStatus(
    String email,
    UpdateStatusRequestModel request,
  );
}

class DriverAllRemoteDataSourceImpl implements DriverAllRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  @override
  Future<Result<void>> updateOnlineStatus(
    String email,
    UpdateStatusRequestModel request,
  ) async {
    try {
      final result = await apiService.patch(
        ApiEndPoint.updateOnlineStatus + email,
        body: request.toJson(),
      );

      return result.fold((l) => left(l.message), (r) => right(null));
    } catch (e) {
      return left(e.toString());
    }
  }
}
