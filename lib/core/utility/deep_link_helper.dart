import 'package:cabwire/data/services/deep_link/deep_link_service_impl.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class DeepLinkHelper {
  /// Generate a shareable deep link for a ride
  static String generateRideLink(String rideId) {
    return DeepLinkServiceImpl.generateDeepLink(rideId, useCustomDomain: true);
  }

  /// Share a ride link via system share dialog
  static Future<void> shareRideLink(String rideId, {String? message}) async {
    final link = generateRideLink(rideId);
    final shareText =
        message != null ? '$message\n\n$link' : 'Join my ride: $link';

    await Share.share(shareText);
  }

  /// Copy ride link to clipboard
  static Future<void> copyRideLinkToClipboard(String rideId) async {
    final link = generateRideLink(rideId);
    await Clipboard.setData(ClipboardData(text: link));
  }

  /// Extract ride ID from any supported deep link format
  static String? extractRideId(String link) {
    return DeepLinkServiceImpl.extractRideIdFromLink(link);
  }

  /// Check if a link is a valid Cabwire deep link
  static bool isValidLink(String link) {
    return DeepLinkServiceImpl.isValidCabwireLink(link);
  }

  /// Get different link formats for a ride
  static Map<String, String> getAllLinkFormats(String rideId) {
    return {
      'http_domain': 'http://31.97.98.240:4173/live-trip/$rideId',
      'custom_scheme': 'cabwire://live-trip/$rideId',
      'https_domain':
          'https://cabwire.app/live-trip/$rideId', // if you have HTTPS later
    };
  }
}
