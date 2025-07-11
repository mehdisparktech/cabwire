import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/notification_response_model.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<ApiFailure, List<NotificationResponseModel>>>
  getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService apiService;

  NotificationRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<ApiFailure, List<NotificationResponseModel>>>
  getNotifications() async {
    final result = await apiService.get(
      ApiEndPoint.notification,
      header: {'Authorization': 'Bearer ${LocalStorage.token}'},
    );
    return result.fold(
      (failure) => left(failure),
      (success) => right([NotificationResponseModel.fromJson(success.data)]),
    );
  }
}
