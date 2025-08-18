import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/data/services/deep_link/deep_link_service_impl.dart';
import 'package:cabwire/domain/services/deep_link_service.dart';
import 'package:cabwire/presentation/common/screens/live_trips/ui/live_trips_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkHandler {
  static final DeepLinkService _deepLinkService = locate<DeepLinkService>();

  static Future<void> initialize() async {
    await _deepLinkService.initialize();

    // Listen for incoming deep links
    _deepLinkService.linkStream.listen((link) {
      handleDeepLink(link);
    });

    // Handle initial link if app was opened via deep link
    final initialLinkResult = await _deepLinkService.handleInitialLink();
    initialLinkResult.fold(
      (error) => debugPrint('Error getting initial link: $error'),
      (link) {
        if (link != null) {
          handleDeepLink(link);
        }
      },
    );
  }

  static void handleDeepLink(String link) {
    debugPrint('Handling deep link: $link');

    final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
    if (rideId != null) {
      // Navigate to live trips screen with the ride ID
      Get.to(() => LiveTripsScreen(rideId: rideId));
    } else {
      debugPrint('Could not extract ride ID from link: $link');
    }
  }

  static void dispose() {
    _deepLinkService.dispose();
  }
}
