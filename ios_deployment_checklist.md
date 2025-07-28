# iOS App Store Deployment Checklist for Cabwire

## ✅ Completed Items

### 1. Info.plist Permissions
- ✅ Location permissions (NSLocationWhenInUseUsageDescription, NSLocationAlwaysUsageDescription)
- ✅ Camera permission (NSCameraUsageDescription)
- ✅ Photo library permission (NSPhotoLibraryUsageDescription)
- ✅ Microphone permission (NSMicrophoneUsageDescription)
- ✅ Background modes for location and notifications
- ✅ App Transport Security settings
- ✅ Face ID permission (NSFaceIDUsageDescription)
- ✅ Motion usage permission (NSMotionUsageDescription)
- ✅ Contacts permission (NSContactsUsageDescription)
- ✅ Calendar permission (NSCalendarsUsageDescription)
- ✅ Bluetooth permissions
- ✅ ITSAppUsesNonExemptEncryption set to false
- ✅ URL schemes configuration
- ✅ Required device capabilities

### 2. Basic Configuration
- ✅ Bundle identifier configured
- ✅ App display name set to "Cabwire"
- ✅ Minimum iOS version set to 14.0
- ✅ Supported orientations configured

## ⚠️ Items to Verify/Complete

### 3. App Icons and Launch Screen
- [ ] App icons for all required sizes (20x20 to 1024x1024)
- [ ] Launch screen configured properly
- [ ] Dark mode support for icons and launch screen

### 4. Build Settings (Check in Xcode)
- [ ] Code signing identity set for Release
- [ ] Provisioning profile configured
- [ ] Bundle identifier matches App Store Connect
- [ ] Version and build number incremented
- [ ] Bitcode enabled (if required)
- [ ] Strip debug symbols in Release build

### 5. Firebase Configuration
- [ ] GoogleService-Info.plist added to iOS project
- [ ] Firebase app configured for production
- [ ] Push notification certificates uploaded to Firebase

### 6. Google Maps API
- [ ] Google Maps API key configured in AppDelegate.swift
- [ ] API key restrictions set properly for production

### 7. App Store Connect Configuration
- [ ] App created in App Store Connect
- [ ] App metadata filled (description, keywords, screenshots)
- [ ] Privacy policy URL provided
- [ ] Age rating completed
- [ ] Pricing and availability set

### 8. Testing Requirements
- [ ] TestFlight testing completed
- [ ] All app features tested on physical devices
- [ ] Location services tested in different scenarios
- [ ] Push notifications tested
- [ ] Payment integration tested (if applicable)

### 9. Privacy and Security
- [ ] Privacy manifest file (if required for iOS 17+)
- [ ] Data collection practices declared
- [ ] Third-party SDK privacy compliance
- [ ] Network security configuration reviewed

### 10. Performance and Quality
- [ ] App launch time optimized
- [ ] Memory usage optimized
- [ ] Network requests optimized
- [ ] Crash-free rate above 99%

## 🔧 Immediate Actions Required

### 1. Check App Icons
Run this command to verify app icons:
```bash
ls -la ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

### 2. Verify GoogleService-Info.plist
```bash
ls -la ios/Runner/GoogleService-Info.plist
```

### 3. Check AppDelegate.swift for API keys
```bash
cat ios/Runner/AppDelegate.swift
```

### 4. Build for Release
```bash
flutter build ios --release
```

### 5. Archive in Xcode
- Open ios/Runner.xcworkspace in Xcode
- Select "Any iOS Device" as target
- Product → Archive
- Upload to App Store Connect

## 📝 Common Issues to Watch For

1. **Missing API Keys**: Google Maps, Firebase configuration
2. **Incorrect Bundle ID**: Must match App Store Connect
3. **Missing Permissions**: Users will get crashes if permissions not declared
4. **Large App Size**: Optimize assets and remove unused dependencies
5. **Background Location**: Requires special justification for App Store review
6. **Third-party Libraries**: Ensure all are App Store compliant

## 🚨 Critical for Taxi App

Since this is a taxi booking app, pay special attention to:
- Location permissions and background location usage
- Push notification setup for ride updates
- Payment processing compliance
- Driver verification and safety features
- Real-time location tracking justification