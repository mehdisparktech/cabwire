import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/domain/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareTripPresenter {
  final ShareService _shareService = locate<ShareService>();

  Future<void> shareToWhatsApp(String rideId) async {
    final shareLink = _shareService.generateTripShareLink(rideId);
    final message = 'Track my live trip on Cabwire: $shareLink';

    final result = await _shareService.shareToWhatsApp(message);
    result.fold(
      (error) => _showErrorMessage(error),
      (_) => _showSuccessMessage('Shared to WhatsApp successfully'),
    );
  }

  Future<void> shareToMessenger(String rideId) async {
    final shareLink = _shareService.generateTripShareLink(rideId);
    final message = 'Track my live trip on Cabwire: $shareLink';

    final result = await _shareService.shareToMessenger(message);
    result.fold(
      (error) => _showErrorMessage(error),
      (_) => _showSuccessMessage('Shared to Messenger successfully'),
    );
  }

  Future<void> shareViaEmail(String rideId) async {
    final shareLink = _shareService.generateTripShareLink(rideId);
    const subject = 'Track My Live Trip - Cabwire';
    final body = '''
Hi,

I'm currently on a trip with Cabwire. You can track my live location using this link:

$shareLink

This link will show you my real-time location and trip progress.

Thanks!
''';

    final result = await _shareService.shareViaEmail(subject, body);
    result.fold(
      (error) => _showErrorMessage(error),
      (_) => _showSuccessMessage('Email app opened successfully'),
    );
  }

  Future<void> shareGeneral(String rideId) async {
    final shareLink = _shareService.generateTripShareLink(rideId);
    final message = 'Track my live trip on Cabwire: $shareLink';

    final result = await _shareService.shareText(message);
    result.fold(
      (error) => _showErrorMessage(error),
      (_) => _showSuccessMessage('Share options opened successfully'),
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
}
