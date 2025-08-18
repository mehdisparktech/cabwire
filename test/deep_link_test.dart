import 'package:flutter_test/flutter_test.dart';
import 'package:cabwire/data/services/deep_link/deep_link_service_impl.dart';

void main() {
  group('DeepLinkService Tests', () {
    test('should extract ride ID from custom scheme', () {
      const link = 'cabwire://live-trip/test123';
      final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
      expect(rideId, equals('test123'));
    });

    test('should extract ride ID from HTTP domain', () {
      const link = 'http://31.97.98.240:4173/live-trip/ride456';
      final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
      expect(rideId, equals('ride456'));
    });

    test('should extract ride ID from HTTPS cabwire.app', () {
      const link = 'https://cabwire.app/live-trip/ride789';
      final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
      expect(rideId, equals('ride789'));
    });

    test('should return null for invalid links', () {
      const invalidLinks = [
        'http://example.com/live-trip/test',
        'cabwire://invalid/test',
        'invalid-url',
        'http://31.97.98.240:4173/wrong-path/test',
      ];

      for (final link in invalidLinks) {
        final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
        expect(rideId, isNull, reason: 'Link: $link should return null');
      }
    });

    test('should generate correct deep links', () {
      const rideId = 'test123';

      // Test custom domain
      final customDomainLink = DeepLinkServiceImpl.generateDeepLink(rideId);
      expect(
        customDomainLink,
        equals('http://31.97.98.240:4173/live-trip/test123'),
      );

      // Test custom scheme
      final customSchemeLink = DeepLinkServiceImpl.generateDeepLink(
        rideId,
        useCustomDomain: false,
      );
      expect(customSchemeLink, equals('cabwire://live-trip/test123'));
    });

    test('should validate Cabwire links correctly', () {
      const validLinks = [
        'cabwire://live-trip/test123',
        'http://31.97.98.240:4173/live-trip/ride456',
        'https://cabwire.app/live-trip/ride789',
      ];

      const invalidLinks = [
        'http://example.com/live-trip/test',
        'cabwire://invalid/test',
        'invalid-url',
        'http://31.97.98.240:4173/wrong-path/test',
      ];

      for (final link in validLinks) {
        expect(
          DeepLinkServiceImpl.isValidCabwireLink(link),
          isTrue,
          reason: 'Link: $link should be valid',
        );
      }

      for (final link in invalidLinks) {
        expect(
          DeepLinkServiceImpl.isValidCabwireLink(link),
          isFalse,
          reason: 'Link: $link should be invalid',
        );
      }
    });
  });
}
