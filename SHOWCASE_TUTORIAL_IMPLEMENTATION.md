# Showcase Tutorial Implementation

This document describes the implementation of the showcase tutorial system for both passenger and driver home screens in the Cabwire app.

## Overview

The showcase tutorial system provides an interactive onboarding experience for new users, highlighting key features and functionality of the app. It uses the `showcaseview` package to create guided tours with customizable steps.

## Architecture

The implementation follows the Clean Architecture pattern with clear separation of concerns:

### Domain Layer
- `ShowcaseStepEntity`: Represents a single tutorial step
- `ShowcaseService`: Abstract service interface for showcase operations

### Data Layer
- `ShowcaseServiceImpl`: Concrete implementation using SharedPreferences for persistence

### Presentation Layer
- `ShowcasePresenter`: Manages showcase state and business logic
- `ShowcaseUiState`: Represents the UI state for showcase
- `CustomShowcaseWidget`: Reusable widget wrapper for showcase steps
- `ShowcaseTutorialScreen`: Introduction screen before starting tutorial

## Features

### 1. Automatic Tutorial Detection
- Checks if user has seen the tutorial before
- Shows introduction screen for first-time users
- Allows manual tutorial restart via floating action button

### 2. Screen-Specific Tutorials

#### Passenger Home Screen Tutorial Steps:
1. **Profile Section**: User profile and information access
2. **Notifications**: Stay updated with ride notifications
3. **Ride Booking**: Start booking rides
4. **Services Section**: Available services (car, emergency, rental, package)
5. **Live Map**: Real-time location and ride tracking

#### Driver Home Screen Tutorial Steps:
1. **Driver Profile**: Driver profile and status information
2. **Online Toggle**: Switch to go online/offline for ride requests
3. **Notifications**: Receive ride requests and updates
4. **Driver Map**: Location tracking and navigation
5. **Ride Requests**: Accept or decline incoming ride requests

### 3. Persistent State Management
- Uses SharedPreferences to remember tutorial completion
- Supports resetting tutorials for testing
- Screen-specific tutorial tracking

### 4. Customizable UI
- Custom showcase widgets with branded styling
- Flexible target shapes (circle, rectangle, rounded rectangle)
- Consistent overlay colors and opacity
- Responsive text styling

## Implementation Details

### Service Registration
The showcase service and presenter are registered in the dependency injection system:

```dart
// In ServiceSetup
..registerLazySingleton<ShowcaseService>(() => ShowcaseServiceImpl())

// In PresenterSetup  
..registerFactory(() => loadPresenter(
  ShowcasePresenter(
    showcaseService: locate(),
    screenKey: '', // Set dynamically
  ),
))
```

### Usage in Screens

#### 1. Import Required Dependencies
```dart
import 'package:cabwire/presentation/common/components/show_case_widget.dart';
import 'package:cabwire/presentation/common/showcase/presenter/showcase_presenter_factory.dart';
import 'package:cabwire/presentation/common/showcase/ui/screens/showcase_tutorial_screen.dart';
import 'package:showcaseview/showcaseview.dart';
```

#### 2. Initialize Showcase Keys
```dart
// Showcase Keys
final GlobalKey _profileKey = GlobalKey();
final GlobalKey _notificationKey = GlobalKey();
final GlobalKey _rideBookingKey = GlobalKey();
// ... more keys
```

#### 3. Create Showcase Presenter
```dart
late final showcasePresenter = ShowcasePresenterFactory.create('passenger_home');
```

#### 4. Initialize in initState
```dart
@override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeShowcase();
  });
}

Future<void> _initializeShowcase() async {
  await showcasePresenter.initializeShowcase();
  
  if (showcasePresenter.shouldShowAutomatically()) {
    _showTutorialScreen();
  }
}
```

#### 5. Wrap Widgets with ShowCaseWidget
```dart
return ShowCaseWidget(
  onComplete: (index, key) {
    if (index == 4) { // Last step
      showcasePresenter.completeShowcase();
    }
  },
  blurValue: 1,
  builder: (context) => // Your screen content
);
```

#### 6. Wrap Target Widgets
```dart
CustomShowcaseWidget(
  showcaseKey: _profileKey,
  title: 'Your Profile',
  description: 'Tap here to view and edit your profile information',
  targetShapeBorder: const CircleBorder(),
  child: // Your widget
)
```

## File Structure

```
lib/
├── domain/
│   ├── entities/showcase/
│   │   └── showcase_step_entity.dart
│   └── services/
│       └── showcase_service.dart
├── data/
│   └── services/showcase/
│       └── showcase_service_impl.dart
└── presentation/
    └── common/
        ├── components/
        │   └── show_case_widget.dart
        └── showcase/
            ├── presenter/
            │   ├── showcase_presenter.dart
            │   ├── showcase_ui_state.dart
            │   └── showcase_presenter_factory.dart
            └── ui/screens/
                └── showcase_tutorial_screen.dart
```

## Customization

### Adding New Tutorial Steps
1. Update `ShowcaseServiceImpl.getShowcaseSteps()` method
2. Add new `ShowcaseStepEntity` with appropriate details
3. Create corresponding GlobalKey in the screen
4. Wrap target widget with `CustomShowcaseWidget`

### Styling Customization
Modify the `CustomShowcaseWidget` properties:
- `targetShapeBorder`: Shape of the highlight area
- `overlayColor`: Background overlay color
- `overlayOpacity`: Overlay transparency
- `titleTextStyle`: Title text styling
- `descTextStyle`: Description text styling

### Screen-Specific Configuration
Add new screen keys in `ShowcaseServiceImpl.getShowcaseSteps()`:
```dart
case 'new_screen_key':
  return _getNewScreenSteps();
```

## Testing

### Manual Testing
- Use the floating action button to restart tutorials
- Test on fresh app installations
- Verify tutorial completion persistence

### Reset Tutorials
```dart
// Reset specific screen
await showcasePresenter.resetShowcase();

// Reset all tutorials
await showcaseService.resetAllShowcases();
```

## Benefits

1. **Improved User Onboarding**: Guides new users through key features
2. **Reduced Support Queries**: Users understand app functionality better
3. **Feature Discovery**: Highlights less obvious features
4. **Consistent Experience**: Standardized tutorial format across screens
5. **Maintainable Code**: Clean architecture with separation of concerns

## Future Enhancements

1. **Analytics Integration**: Track tutorial completion rates
2. **Dynamic Content**: Server-driven tutorial content
3. **Conditional Tutorials**: Show tutorials based on user behavior
4. **Interactive Elements**: More engaging tutorial interactions
5. **Localization**: Multi-language tutorial support

## Dependencies

- `showcaseview: ^4.0.1`: Core showcase functionality
- `shared_preferences: ^2.5.3`: Tutorial state persistence
- `get: ^4.6.6`: Navigation and state management
- `equatable: ^2.0.5`: Value equality for entities

This implementation provides a robust, maintainable showcase tutorial system that enhances user onboarding while following the app's architectural patterns.