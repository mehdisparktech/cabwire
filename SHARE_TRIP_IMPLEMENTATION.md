# Share Trip Implementation

This document describes the implementation of the "Share Trip" functionality in the Cabwire app.

## Overview

The Share Trip feature allows passengers to share their live trip information with others through various platforms including WhatsApp, Messenger, Email, and other sharing options.

## Features

- **Dropdown Menu**: Click on "Share Trip" shows a dropdown with sharing options
- **Multiple Platforms**: Support for WhatsApp, Messenger, Email, and general sharing
- **Deep Linking**: Shared links open the app directly to the live trip screen using custom scheme `cabwire://`
- **Real-time Tracking**: Recipients can track the live trip progress
- **Debug Screen**: Added debug screen for testing functionality

## ✅ What's Fixed

1. **Deep Linking**: Now uses `app_links` package for proper deep link handling
2. **Custom Scheme**: Uses `cabwire://live-trip/{rideId}` instead of HTTPS URLs
3. **Platform Configuration**: Added Android and iOS deep link configurations
4. **Better Messages**: Enhanced share messages with emojis and clear instructions
5. **Debug Tools**: Added debug screen for easy testing

## Implementation Details

### 1. Share Service (`ShareService`)

**Interface**: `lib/domain/services/share_service.dart`
**Implementation**: `lib/data/services/share/share_service_impl.dart`

Provides methods for:
- `shareText()` - General sharing
- `shareToWhatsApp()` - WhatsApp specific sharing
- `shareToMessenger()` - Messenger specific sharing  
- `shareViaEmail()` - Email sharing
- `generateTripShareLink()` - Creates deep link URLs

### 2. Share Dropdown Component

**File**: `lib/presentation/common/components/share_trip_dropdown.dart`

A reusable PopupMenuButton that shows sharing options with icons and handles user selection.

### 3. Share Presenter

**File**: `lib/presentation/common/components/share_trip_presenter.dart`

Handles the business logic for sharing operations and shows success/error messages.

### 4. Deep Link Handling

**Service**: `lib/domain/services/deep_link_service.dart`
**Implementation**: `lib/data/services/deep_link/deep_link_service_impl.dart`
**Handler**: `lib/core/utility/deep_link_handler.dart`

Processes incoming deep links and navigates to the appropriate screen.

### 5. Updated Components

**TripStoppageInfoWidget**: Updated to include the share dropdown when `rideId` is provided.

## Usage

### In TripStoppageInfoWidget

```dart
TripStoppageInfoWidget(
  stoppageLocation: 'Your destination address',
  rideId: 'your_ride_id_here', // Required for sharing
)
```

### Generated Share Links

Links follow the format: `https://cabwire.app/live-trip/{rideId}`

### Share Messages

**WhatsApp/Messenger/General**:
```
Track my live trip on Cabwire: https://cabwire.app/live-trip/RIDE_ID
```

**Email**:
```
Subject: Track My Live Trip - Cabwire

Hi,

I'm currently on a trip with Cabwire. You can track my live location using this link:

https://cabwire.app/live-trip/RIDE_ID

This link will show you my real-time location and trip progress.

Thanks!
```

## Dependencies

- `share_plus: ^10.1.2` - For native sharing functionality
- `url_launcher: ^6.3.1` - For launching external apps

## Configuration

The services are automatically registered in the dependency injection system via `ServiceSetup`.

## Deep Link Configuration

For production use, you'll need to configure:

1. **Android**: Update `android/app/src/main/AndroidManifest.xml`
2. **iOS**: Update `ios/Runner/Info.plist`
3. **Web**: Configure web server redirects

Example Android configuration:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https"
          android:host="cabwire.app" />
</intent-filter>
```

## Testing

To test the functionality:

1. Navigate to a screen with `TripStoppageInfoWidget` that has a `rideId`
2. Tap "Share Trip" to see the dropdown
3. Select a sharing option
4. Verify the appropriate app opens with the share content
5. Test deep links by opening generated URLs

## Notes

- The share functionality only appears when `rideId` is provided
- Deep link handling is initialized in `main.dart`
- Error handling includes user-friendly snackbar messages
- The implementation follows the existing Clean Architecture pattern
## 🧪 
Testing Instructions

### 1. Access Debug Screen
- Open the app
- Go to Passenger Home Screen
- Tap the orange bug icon (🐛) in the top right
- This opens the Deep Link Test Screen

### 2. Test Share Functionality
- In the debug screen, tap any share button (WhatsApp, Messenger, Email, General)
- This will generate a link like: `cabwire://live-trip/test123`
- Share this link via any messaging app

### 3. Test Deep Link Navigation
- Copy the generated deep link from the debug screen
- Send it to yourself via SMS, WhatsApp, or any messaging app
- Tap the link - it should open the Cabwire app directly
- The app should navigate to LiveTripsScreen with the ride ID

### 4. Alternative Testing
- Use the "Test Deep Link Navigation" button in debug screen
- This simulates clicking a deep link without leaving the app

## 🔧 Technical Changes Made

### New Dependencies Added
```yaml
app_links: ^6.3.2  # Official Flutter deep linking package
```

### Android Configuration (`android/app/src/main/AndroidManifest.xml`)
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="cabwire" />
</intent-filter>
```

### iOS Configuration (`ios/Runner/Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>cabwire.deeplink</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>cabwire</string>
        </array>
    </dict>
</array>
```

### Updated Services
- **DeepLinkServiceImpl**: Now uses `app_links` package for proper deep link handling
- **ShareServiceImpl**: Generates `cabwire://` scheme links instead of HTTPS
- **ShareTripPresenter**: Enhanced messages with better formatting

### New Debug Tools
- **DeepLinkTestScreen**: Comprehensive testing interface
- **Debug Button**: Added to passenger home screen (remove in production)

## 🚀 How It Works Now

1. **Share Process**:
   - User taps "Share Trip" → Dropdown appears
   - User selects platform → App generates `cabwire://live-trip/{rideId}`
   - Link is shared via selected platform

2. **Deep Link Process**:
   - Recipient receives link → Taps link
   - OS recognizes `cabwire://` scheme → Opens Cabwire app
   - App extracts ride ID → Navigates to LiveTripsScreen

3. **Link Format**:
   ```
   cabwire://live-trip/RIDE_ID_HERE
   ```

## 📱 Share Message Format

**WhatsApp/Messenger/General**:
```
🚗 Track my live trip on Cabwire!

Click this link to see my real-time location:
cabwire://live-trip/RIDE_ID

You can follow my journey until I reach my destination safely.
```

**Email**:
```
Subject: Track My Live Trip - Cabwire

Hi,

I'm currently on a trip with Cabwire. You can track my live location using this link:

cabwire://live-trip/RIDE_ID

This link will show you my real-time location and trip progress.

Thanks!
```

## 🔍 Troubleshooting

### If Deep Links Don't Work:
1. Make sure you've run `flutter pub get` after adding `app_links`
2. Rebuild the app completely (`flutter clean && flutter pub get && flutter run`)
3. Test on a physical device (deep links may not work properly in simulators)
4. Check that the Android/iOS configurations are properly saved

### If Share Doesn't Work:
1. Check that `share_plus` package is working
2. Test the debug screen first
3. Verify the generated links have the correct format

### Debug Logs:
- Look for logs starting with 🔗, 🆔, 📱, or ❌ in the console
- These show the deep link processing steps

## 🚨 Production Notes

1. **Remove Debug Button**: Remove the debug button from passenger home screen before production
2. **Test on Real Devices**: Always test deep links on physical devices
3. **App Store Review**: Deep linking might require additional app store review
4. **Fallback URLs**: Consider adding HTTPS fallback URLs for better compatibility

## 📋 Files Modified/Created

### New Files:
- `lib/domain/services/deep_link_service.dart`
- `lib/data/services/deep_link/deep_link_service_impl.dart`
- `lib/domain/services/share_service.dart`
- `lib/data/services/share/share_service_impl.dart`
- `lib/presentation/common/components/share_trip_dropdown.dart`
- `lib/presentation/common/components/share_trip_presenter.dart`
- `lib/core/utility/deep_link_handler.dart`
- `lib/presentation/common/screens/debug/deep_link_test_screen.dart`

### Modified Files:
- `pubspec.yaml` - Added `app_links` dependency
- `lib/core/di/setup/service_setup.dart` - Registered new services
- `lib/main.dart` - Initialize deep link handler
- `lib/presentation/passenger/car_booking/ui/widgets/trip_stoppage_info_widget.dart` - Added share functionality
- `lib/presentation/passenger/car_booking/ui/widgets/rideshare_bottom_sheet.dart` - Pass rideId
- `android/app/src/main/AndroidManifest.xml` - Android deep link config
- `ios/Runner/Info.plist` - iOS deep link config
- `lib/presentation/passenger/home/ui/screens/passenger_home_screen.dart` - Added debug button

The implementation is now complete and ready for testing! 🎉