# Xcode Settings for App Store Deployment

## 1. Open Project in Xcode
```bash
open ios/Runner.xcworkspace
```

## 2. Build Settings to Check

### General Tab:
- **Bundle Identifier**: Should match App Store Connect (e.g., com.yourcompany.cabwire)
- **Version**: 1.0.1
- **Build**: 2 (increment for each submission)
- **Deployment Target**: 14.0
- **Team**: Select your Apple Developer Team

### Signing & Capabilities:
- **Automatically manage signing**: ✅ Enabled
- **Team**: Select your Apple Developer Team
- **Provisioning Profile**: Automatic
- **Capabilities to Add**:
  - Push Notifications
  - Background Modes (Location updates, Background fetch, Remote notifications)
  - Maps
  - Location Services

### Build Settings Tab:
- **Code Signing Identity (Release)**: iOS Distribution
- **Strip Debug Symbols During Copy (Release)**: YES
- **Enable Bitcode**: YES (if required)
- **Validate Built Product**: YES

## 3. Required Capabilities

Add these capabilities in Xcode:
1. **Push Notifications**
2. **Background Modes**:
   - Location updates
   - Background fetch  
   - Remote notifications
   - Background processing
3. **Maps**
4. **App Groups** (if using)

## 4. Build Configuration

### For Release Build:
```bash
flutter build ios --release --no-codesign
```

### Archive in Xcode:
1. Select "Any iOS Device (arm64)" as target
2. Product → Archive
3. Wait for archive to complete
4. Distribute App → App Store Connect
5. Upload

## 5. Common Issues & Solutions

### Issue: "GoogleService-Info.plist not found"
**Solution**: Make sure the file is added to Xcode project target

### Issue: "Provisioning profile doesn't match"
**Solution**: 
- Check Bundle ID matches App Store Connect
- Ensure Apple Developer account has proper certificates

### Issue: "Missing required architecture"
**Solution**: Build with --release flag and ensure arm64 architecture

### Issue: "App uses non-exempt encryption"
**Solution**: ITSAppUsesNonExemptEncryption is set to false in Info.plist

## 6. Pre-submission Checklist

- [ ] All required permissions declared in Info.plist
- [ ] GoogleService-Info.plist added and configured
- [ ] App icons for all sizes present
- [ ] Launch screen configured
- [ ] Code signing configured
- [ ] TestFlight testing completed
- [ ] App Store Connect metadata filled
- [ ] Privacy policy URL provided
- [ ] Screenshots uploaded (all required sizes)

## 7. Testing Commands

```bash
# Clean build
flutter clean
flutter pub get

# iOS specific clean
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..

# Build and test
flutter build ios --release
```