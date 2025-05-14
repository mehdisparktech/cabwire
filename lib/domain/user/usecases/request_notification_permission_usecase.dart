import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/user/service/notification_service.dart';
import 'package:cabwire/domain/user/service/error_message_handler.dart';

class RequestNotificationPermissionUsecase extends BaseUseCase<void> {
  final NotificationService _notificationService;

  RequestNotificationPermissionUsecase(
    this._notificationService,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, void>> execute({
    required VoidCallback onGrantedOrSkippedForNow,
    required VoidCallback onDenied,
  }) async {
    return mapResultToEither(() async {
      await _notificationService.askNotificationPermission(
        onGrantedOrSkippedForNow: onGrantedOrSkippedForNow,
        onDenied: onDenied,
      );
      return;
    });
  }
}
