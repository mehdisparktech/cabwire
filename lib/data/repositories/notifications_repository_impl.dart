import 'package:cabwire/data/datasources/remote/notification_remote_data_source.dart';
import 'package:cabwire/data/models/notification_response_model.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/repositories/notifications_repository.dart';
import 'package:fpdart/fpdart.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ApiFailure, List<NotificationResponseModel>>>
  getNotifications() async {
    return remoteDataSource.getNotifications();
  }
}
