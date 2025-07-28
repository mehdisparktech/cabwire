import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/data/models/notification_response_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotificationsRepository {
  Future<Either<ApiFailure, List<NotificationResponseModel>>>
  getNotifications();
}
