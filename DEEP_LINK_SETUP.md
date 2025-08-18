# Deep Link Setup for Cabwire

আপনার Cabwire অ্যাপে এখন `http://31.97.98.240:4173/` domain দিয়ে deep link support add করা হয়েছে।

## Supported Link Formats

আপনার অ্যাপ এখন এই ধরনের deep link handle করতে পারে:

1. **HTTP Domain**: `http://31.97.98.240:4173/live-trip/RIDE_ID`
2. **Custom Scheme**: `cabwire://live-trip/RIDE_ID`
3. **HTTPS Domain**: `https://cabwire.app/live-trip/RIDE_ID` (future support)

## Example Links

```
http://31.97.98.240:4173/live-trip/abc123
cabwire://live-trip/abc123
https://cabwire.app/live-trip/abc123
```

## How to Use

### 1. Generate Deep Links

```dart
import 'package:cabwire/core/utility/deep_link_helper.dart';

// Generate link with your domain
String link = DeepLinkHelper.generateRideLink('ride123');
// Returns: http://31.97.98.240:4173/live-trip/ride123

// Get all available formats
Map<String, String> allFormats = DeepLinkHelper.getAllLinkFormats('ride123');
```

### 2. Share Links

```dart
// Share via system share dialog
await DeepLinkHelper.shareRideLink('ride123', message: 'Join my ride!');

// Copy to clipboard
await DeepLinkHelper.copyRideLinkToClipboard('ride123');
```

### 3. Handle Incoming Links

```dart
import 'package:cabwire/data/services/deep_link/deep_link_service_impl.dart';

// Extract ride ID from any link format
String? rideId = DeepLinkHelper.extractRideId('http://31.97.98.240:4173/live-trip/abc123');
// Returns: 'abc123'

// Validate if link is supported
bool isValid = DeepLinkHelper.isValidLink('http://31.97.98.240:4173/live-trip/abc123');
// Returns: true
```

## Configuration Files Updated

### Android (`android/app/src/main/AndroidManifest.xml`)
- Added HTTP intent filter for `31.97.98.240:4173`
- Existing custom scheme `cabwire://` still works

### iOS (`ios/Runner/Info.plist`)
- Added HTTP URL scheme support
- Existing custom scheme `cabwire://` still works

## Testing

Run the tests to verify everything works:

```bash
flutter test test/deep_link_test.dart
```

## Usage in Your App

1. **Initialize Deep Link Service** (already done in your DI setup):
```dart
final deepLinkService = locate<DeepLinkService>();
await deepLinkService.initialize();
```

2. **Listen for Incoming Links**:
```dart
deepLinkService.linkStream.listen((String link) {
  final rideId = DeepLinkHelper.extractRideId(link);
  if (rideId != null) {
    // Navigate to live trip screen
    navigateToLiveTrip(rideId);
  }
});
```

3. **Handle App Launch via Deep Link**:
```dart
final result = await deepLinkService.handleInitialLink();
result.fold(
  (error) => print('Error: $error'),
  (link) => {
    if (link != null) {
      final rideId = DeepLinkHelper.extractRideId(link);
      if (rideId != null) navigateToLiveTrip(rideId);
    }
  },
);
```

## Next Steps

1. **Test on Device**: Build and install the app, then test with actual links
2. **Backend Integration**: Make sure your backend generates links using the new domain
3. **Share Feature**: Use `DeepLinkHelper.shareRideLink()` in your share functionality
4. **Analytics**: Track deep link usage for analytics

## Troubleshooting

- Make sure the domain `31.97.98.240:4173` is accessible
- Test both custom scheme and HTTP links
- Check device logs for deep link debugging messages
- Verify intent filters are properly configured in AndroidManifest.xml