import 'package:flutter_test/flutter_test.dart';
import 'package:cabwire/data/services/deep_link/deep_link_service_impl.dart';

void main() {
  group('DeepLinkService Tests', () {
    test('should extract ride ID from custom scheme', () {
      const link = 'cabwire://live-trip/test123';
      final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
      expect(rideId, equals('test123'));
    });

    test('should extract ride ID from HTTPS website', () {
      const link = 'https://www.cabwire.com/live-trip/ride456';
      final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
      expect(rideId, equals('ride456'));
    });

    test('should return null for invalid links', () {
      const invalidLinks = [
        'http://example.com/live-trip/test',
        'https://wrong-domain.com/live-trip/test',
        'cabwire://invalid/test',
        'invalid-url',
        'https://www.cabwire.com/wrong-path/test',
      ];

      for (final link in invalidLinks) {
        final rideId = DeepLinkServiceImpl.extractRideIdFromLink(link);
        expect(rideId, isNull, reason: 'Link: $link should return null');
      }
    });

    test('should generate correct deep links', () {
      const rideId = 'test123';

      // Test website link
      final websiteLink = DeepLinkServiceImpl.generateDeepLink(rideId);
      expect(websiteLink, equals('https://www.cabwire.com/live-trip/test123'));

      // Test custom scheme
      final customSchemeLink = DeepLinkServiceImpl.generateDeepLink(
        rideId,
        useWebsite: false,
      );
      expect(customSchemeLink, equals('cabwire://live-trip/test123'));
    });

    test('should validate Cabwire links correctly', () {
      const validLinks = [
        'cabwire://live-trip/test123',
        'https://www.cabwire.com/live-trip/ride456',
      ];

      const invalidLinks = [
        'http://example.com/live-trip/test',
        'https://wrong-domain.com/live-trip/test',
        'cabwire://invalid/test',
        'invalid-url',
        'https://www.cabwire.com/wrong-path/test',
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
