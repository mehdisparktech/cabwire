import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/services/notification_service.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';

class CheckNotificationPermissionUsecase extends BaseUseCase<bool> {
  final NotificationService _notificationService;

  CheckNotificationPermissionUsecase(
    this._notificationService,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, bool>> execute() async {
    return mapResultToEither(() async {
      return await _notificationService.isNotificationAllowed();
    });
  }
}
