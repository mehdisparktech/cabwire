import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:cabwire/domain/services/deep_link_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';

class DeepLinkServiceImpl implements DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final StreamController<String> _linkStreamController =
      StreamController<String>.broadcast();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  Stream<String> get linkStream => _linkStreamController.stream;

  @override
  Future<void> initialize() async {
    try {
      // Listen for incoming links when app is already running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          debugPrint('Received deep link: $uri');
          _linkStreamController.add(uri.toString());
        },
        onError: (err) {
          debugPrint('Deep link error: $err');
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize deep links: $e');
    }
  }

  @override
  Future<Either<String, String?>> handleInitialLink() async {
    try {
      // Get the initial link if app was opened via deep link
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        return Right(initialUri.toString());
      }
      return const Right(null);
    } catch (e) {
      return Left('Failed to get initial link: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _linkStreamController.close();
  }

  // Helper method to extract ride ID from deep link
  static String? extractRideIdFromLink(String link) {
    debugPrint('🔍 Parsing link: $link');

    final uri = Uri.tryParse(link);
    if (uri == null) {
      debugPrint('❌ Failed to parse URI');
      return null;
    }

    debugPrint('🔍 URI scheme: ${uri.scheme}');
    debugPrint('🔍 URI host: ${uri.host}');
    debugPrint('🔍 URI port: ${uri.port}');
    debugPrint('🔍 URI path: ${uri.path}');
    debugPrint('🔍 URI pathSegments: ${uri.pathSegments}');

    // Handle different link formats
    // https://cabwire.app/live-trip/RIDE_ID
    // http://31.97.98.240:4173/live-trip/RIDE_ID
    // cabwire://live-trip/RIDE_ID

    // For custom scheme like cabwire://live-trip/RIDE_ID
    if (uri.scheme == 'cabwire') {
      // In cabwire://live-trip/test123:
      // - host = "live-trip"
      // - path = "/test123"
      // - pathSegments = ["test123"]

      if (uri.host == 'live-trip' && uri.pathSegments.isNotEmpty) {
        final rideId = uri.pathSegments[0];
        debugPrint('✅ Extracted ride ID from custom scheme: $rideId');
        return rideId;
      }
    }

    // For HTTP/HTTPS URLs like http://31.97.98.240:4173/live-trip/RIDE_ID
    if ((uri.scheme == 'http' || uri.scheme == 'https')) {
      // Check if it's our specific domain
      if ((uri.host == '31.97.98.240' && uri.port == 4173) ||
          uri.host == 'cabwire.app') {
        if (uri.pathSegments.length >= 2 &&
            uri.pathSegments[0] == 'live-trip') {
          final rideId = uri.pathSegments[1];
          debugPrint('✅ Extracted ride ID from HTTP/HTTPS: $rideId');
          return rideId;
        }
      }
    }

    debugPrint('❌ Could not extract ride ID from URI');
    return null;
  }

  // Helper method to generate deep link for sharing
  static String generateDeepLink(String rideId, {bool useCustomDomain = true}) {
    if (useCustomDomain) {
      return 'http://31.97.98.240:4173/live-trip/$rideId';
    } else {
      return 'cabwire://live-trip/$rideId';
    }
  }

  // Helper method to check if a link is a valid Cabwire deep link
  static bool isValidCabwireLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null) return false;

    // Check custom scheme
    if (uri.scheme == 'cabwire' && uri.host == 'live-trip') {
      return true;
    }

    // Check HTTP domain
    if ((uri.scheme == 'http' || uri.scheme == 'https')) {
      if ((uri.host == '31.97.98.240' && uri.port == 4173) ||
          uri.host == 'cabwire.app') {
        return uri.pathSegments.isNotEmpty &&
            uri.pathSegments[0] == 'live-trip';
      }
    }

    return false;
  }
}
