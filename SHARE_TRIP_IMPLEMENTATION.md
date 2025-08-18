# Share Trip Implementation

This document describes the implementation of the "Share Trip" functionality in the Cabwire app.

## Overview

The Share Trip feature allows passengers to share their live trip information with others through various platforms including WhatsApp, Messenger, Email, and other sharing options.

## Features

- **Dropdown Menu**: Click on "Share Trip" shows a dropdown with sharing options
- **Multiple Platforms**: Support for WhatsApp, Messenger, Email, and general sharing
- **Deep Linking**: Shared links open the app directly to the live trip screen
- **Real-time Tracking**: Recipients can track the live trip progress

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