# Deep Link Setup for Cabwire

আপনার Cabwire অ্যাপে এখন `https://www.cabwire.com` domain দিয়ে deep link support add করা হয়েছে।

## Supported Link Formats

আপনার অ্যাপ এখন এই ধরনের deep link handle করতে পারে:

1. **Website**: `https://www.cabwire.com/live-trip/RIDE_ID`
2. **Custom Scheme**: `cabwire://live-trip/RIDE_ID`

## Example Links

```
https://www.cabwire.com/live-trip/abc123
cabwire://live-trip/abc123
```

## How to Use

### 1. Generate Deep Links

```dart
import 'package:cabwire/core/utility/deep_link_helper.dart';

// Generate link with your website
String link = DeepLinkHelper.generateRideLink('ride123');
// Returns: https://www.cabwire.com/live-trip/ride123

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
String? rideId = DeepLinkHelper.extractRideId('https://www.cabwire.com/live-trip/abc123');
// Returns: 'abc123'

// Validate if link is supported
bool isValid = DeepLinkHelper.isValidLink('https://www.cabwire.com/live-trip/abc123');
// Returns: true
```

## Configuration Files Updated

### Android (`android/app/src/main/AndroidManifest.xml`)
- Added HTTPS intent filter for `www.cabwire.com`
- Existing custom scheme `cabwire://` still works

### iOS (`ios/Runner/Info.plist`)
- Added HTTPS URL scheme support
- Existing custom scheme `cabwire://` still works

### Domain Verification (`assetlinks.json`)
- Place this file at `https://www.cabwire.com/.well-known/assetlinks.json`
- Required for Android App Links verification

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

1. **Domain Setup**: Upload `assetlinks.json` to `https://www.cabwire.com/.well-known/assetlinks.json`
2. **Test on Device**: Build and install the app, then test with actual links
3. **Backend Integration**: Make sure your backend generates links using `https://www.cabwire.com`
4. **Share Feature**: Use `DeepLinkHelper.shareRideLink()` in your share functionality
5. **Analytics**: Track deep link usage for analytics

## Domain Verification Setup

For Android App Links to work properly, you need to:

1. **Upload assetlinks.json**: Place the `assetlinks.json` file at:
   ```
   https://www.cabwire.com/.well-known/assetlinks.json
   ```

2. **Verify Domain**: Test the verification at:
   ```
   https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://www.cabwire.com
   ```

## Troubleshooting

- Make sure `https://www.cabwire.com` is accessible and has SSL certificate
- Verify `assetlinks.json` is properly uploaded and accessible
- Test both custom scheme and HTTPS links
- Check device logs for deep link debugging messages
- Use `adb shell am start -W -a android.intent.action.VIEW -d "https://www.cabwire.com/live-trip/test123" com.example.cabwire` to test on Android