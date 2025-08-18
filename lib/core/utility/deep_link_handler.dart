import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/data/services/deep_link/deep_link_service_impl.dart';
import 'package:cabwire/domain/services/deep_link_service.dart';
import 'package:cabwire/presentation/common/screens/live_trips/ui/live_trips_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkHandler {
  static final DeepLinkService _deepLinkService = locate<DeepLinkService>();

  // Track if app was opened via deep link
  static String? _pendingRideId;

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
          handleInitialDeepLink(link);
        }
      },
    );
  }

  // Handle initial deep link (when app is opened via deep link)
  static void handleInitialDeepLink(String link) {
    debugPrint('🔗 Handling initial deep link: $link');

    final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
    debugPrint('🆔 Extracted ride ID: $rideId');

    if (rideId != null) {
      _pendingRideId = rideId;
      debugPrint('📝 Stored pending ride ID: $rideId');
    }
  }

  // Handle deep link when app is already running
  static void handleDeepLink(String link) {
    debugPrint('🔗 Handling deep link (app running): $link');

    final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
    debugPrint('🆔 Extracted ride ID: $rideId');

    if (rideId != null) {
      debugPrint('📱 Navigating to LiveTripsScreen with rideId: $rideId');
      _navigateToLiveTrips(rideId);
    } else {
      debugPrint('❌ Could not extract ride ID from link: $link');
    }
  }

  // Navigate to LiveTripsScreen
  static void _navigateToLiveTrips(String rideId) {
    // Check if GetX is ready for navigation
    if (Get.context != null) {
      // Navigate to live trips screen with the ride ID
      Get.to(() => LiveTripsScreen(rideId: rideId));
    } else {
      // Fallback: use navigator key if GetX context isn't available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (Get.context != null) {
            Get.to(() => LiveTripsScreen(rideId: rideId));
          } else {
            debugPrint('❌ GetX context not available for navigation');
          }
        });
      });
    }
  }

  // Check if there's a pending deep link and handle it
  static void handlePendingDeepLink() {
    if (_pendingRideId != null) {
      debugPrint('🚀 Handling pending deep link with ride ID: $_pendingRideId');
      _navigateToLiveTrips(_pendingRideId!);
      _pendingRideId = null; // Clear after handling
    }
  }

  // Check if app was opened via deep link
  static bool get hasInitialDeepLink => _pendingRideId != null;

  // Get the initial ride ID if available
  static String? get initialRideId => _pendingRideId;

  // Clear the pending ride ID (call this after handling initial deep link)
  static void clearPendingRideId() {
    _pendingRideId = null;
  }

  static void dispose() {
    _deepLinkService.dispose();
  }
}
