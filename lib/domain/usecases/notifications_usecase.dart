import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/data/models/notification_response_model.dart';
import 'package:cabwire/domain/repositories/notifications_repository.dart';

class NotificationsUseCase
    extends BaseUseCase<List<NotificationResponseModel>> {
  final NotificationsRepository _repository;

  NotificationsUseCase(this._repository, super.errorMessageHandler);

  Future<List<NotificationResponseModel>> execute() async {
    final result = await _repository.getNotifications();
    return result.fold((failure) => throw failure, (success) => success);
  }
}
