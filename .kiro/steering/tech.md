# Technology Stack

## Flutter & Dart
- **Flutter SDK**: Managed via FVM (Flutter Version Management) using stable channel
- **Dart SDK**: ^3.7.2
- **Target Platforms**: iOS, Android, macOS, Linux, Windows

## Core Dependencies

### State Management & Architecture
- **GetX** (^4.6.6): State management, dependency injection, and navigation
- **get_it** (^8.0.2): Service locator pattern for dependency injection
- **fpdart** (^1.1.0): Functional programming utilities, used for `Result<T>` type
- **equatable** (^2.0.5): Value equality for entities and states

### Backend & API
- **http** (^1.3.0): HTTP client for API calls
- **dio** (^5.8.0+1): Advanced HTTP client with interceptors
- **socket_io_client** (^3.1.2): Real-time communication via WebSocket

### Firebase Services
- **firebase_core** (^3.11.0): Firebase initialization
- **cloud_firestore** (^5.6.3): NoSQL database
- **firebase_messaging** (^15.2.2): Push notifications
- **firebase_analytics** (^11.4.2): Analytics tracking
- **firebase_crashlytics** (^4.3.2): Crash reporting
- **firebase_storage** (^12.4.2): File storage

### Location & Maps
- **google_maps_flutter** (^2.12.1): Google Maps integration
- **geolocator** (^14.0.1): Location services
- **geocoding** (^2.1.1): Address geocoding
- **flutter_polyline_points** (^2.1.0): Route polylines
- **permission_handler** (^12.0.0+1): Runtime permissions

### UI & Media
- **responsive_sizer** (^3.3.1): Responsive design utilities
- **flutter_svg** (^2.1.0): SVG image support
- **cached_network_image** (^3.4.1): Image caching
- **image_picker** (^1.1.2): Camera/gallery access
- **image_cropper** (^9.1.0): Image editing

### Storage & Persistence
- **shared_preferences** (^2.5.3): Key-value storage
- **hive** (^2.2.3): Local database
- **path_provider** (^2.1.5): File system paths

## Development Tools

### Code Generation
- **build_runner** (^2.4.14): Code generation runner
- **hive_generator** (^2.0.1): Hive model generation

### Code Quality
- **flutter_lints** (^5.0.0): Dart/Flutter linting rules
- **analysis_options.yaml**: Static analysis configuration

### Logging & Debugging
- **talker_logger** (^4.4.1): Advanced logging
- **logger** (^2.5.0): Simple logging utility

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Run the app (debug mode)
flutter run

# Run with specific flavor/target
flutter run --debug
flutter run --release
```

### Build & Release
```bash
# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build for specific platforms
flutter build macos
flutter build linux
flutter build windows
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

### FVM Commands
```bash
# Use stable Flutter version
fvm use stable

# Install Flutter version
fvm install stable

# Run Flutter commands via FVM
fvm flutter run
fvm flutter build apk
```

## Environment Configuration
- **Environment Variables**: Managed via `.env` file and `flutter_dotenv`
- **API Endpoints**: Configured in `lib/core/config/api/api_end_point.dart`
- **Build Configurations**: Separate configurations for development, staging, and production