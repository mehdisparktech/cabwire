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
    debugPrint('🔍 URI path: ${uri.path}');
    debugPrint('🔍 URI pathSegments: ${uri.pathSegments}');

    // Handle different link formats
    // https://cabwire.app/live-trip/RIDE_ID
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

    // For HTTPS URLs like https://cabwire.app/live-trip/RIDE_ID
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'live-trip') {
      final rideId = uri.pathSegments[1];
      debugPrint('✅ Extracted ride ID from HTTPS: $rideId');
      return rideId;
    }

    debugPrint('❌ Could not extract ride ID from URI');
    return null;
  }
}
