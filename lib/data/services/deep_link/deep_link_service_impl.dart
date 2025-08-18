import 'dart:async';
import 'package:cabwire/domain/services/deep_link_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/services.dart';

class DeepLinkServiceImpl implements DeepLinkService {
  static const MethodChannel _channel = MethodChannel('cabwire/deep_link');
  final StreamController<String> _linkStreamController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get linkStream => _linkStreamController.stream;

  @override
  Future<void> initialize() async {
    try {
      // Set up method channel to listen for deep links
      _channel.setMethodCallHandler(_handleMethodCall);
    } catch (e) {
      // Handle initialization error
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onDeepLink':
        final String link = call.arguments as String;
        _linkStreamController.add(link);
        break;
    }
  }

  @override
  Future<Either<String, String?>> handleInitialLink() async {
    try {
      // For now, we'll use a simple approach
      // In a real implementation, you might use packages like app_links or uni_links
      return const Right(null);
    } catch (e) {
      return Left('Failed to get initial link: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _linkStreamController.close();
  }

  // Helper method to extract ride ID from deep link
  static String? extractRideIdFromLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null) return null;

    // Handle different link formats
    // https://cabwire.app/live-trip/RIDE_ID
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'live-trip') {
      return uri.pathSegments[1];
    }

    return null;
  }
}
