# Project Structure

## Clean Architecture Organization

The project follows **Clean Architecture** with clear layer separation:

```
lib/
├── core/           # Shared utilities and base classes
├── data/           # Data layer (API, models, repositories)
├── domain/         # Domain layer (entities, use cases, interfaces)
└── presentation/   # Presentation layer (UI, presenters, screens)
```

## Core Layer (`lib/core/`)

### Base Classes
- `base/base_presenter.dart` - Base presenter with common functionality
- `base/base_ui_state.dart` - Base UI state extending Equatable
- `base/base_use_case.dart` - Base use case interface
- `base/result.dart` - Result type alias (`Either<String, T>`)

### Configuration
- `config/api/api_end_point.dart` - API endpoint constants
- `config/app_*.dart` - App-wide configuration (colors, themes, assets)
- `static/` - Static constants (strings, colors, URLs)

### Dependency Injection
- `di/service_locator.dart` - Main service locator setup
- `di/setup/` - Modular DI setup (services, repositories, use cases, presenters)

### Utilities
- `utility/` - Helper classes (validation, navigation, logging)
- `external_libs/` - Custom external library implementations

## Data Layer (`lib/data/`)

### Models
- `models/` - Data transfer objects for API communication
- Organized by feature (e.g., `models/passenger/`, `models/driver/`)

### Data Sources
- `datasources/remote/` - API data sources (abstract + implementation)
- `datasources/local/` - Local storage data sources

### Repositories
- `repositories/` - Repository implementations
- Organized by feature with `*_repository_impl.dart` naming

### Services
- `services/api/` - API service implementation
- `services/storage/` - Storage services
- `services/notification/` - Push notification services

### Mappers
- `mappers/` - Convert between data models and domain entities
- Named as `*_mapper.dart`

## Domain Layer (`lib/domain/`)

### Entities
- `entities/` - Pure business objects
- Organized by feature (e.g., `entities/passenger/`, `entities/driver/`)

### Repositories
- `repositories/` - Abstract repository interfaces
- Define contracts for data layer implementations

### Use Cases
- `usecases/` - Business logic operations
- Organized by feature with clear naming (`*_usecase.dart`)

### Services
- `services/` - Abstract service interfaces
- Define contracts for external services

## Presentation Layer (`lib/presentation/`)

### Feature Organization
```
presentation/
├── common/         # Shared UI components and screens
├── driver/         # Driver-specific features
└── passenger/      # Passenger-specific features
```

### Feature Structure
Each feature follows this pattern:
```
feature_name/
├── ui/
│   ├── screens/    # Screen widgets
│   └── components/ # Reusable UI components
├── presenter/      # Business logic for UI
└── models/         # UI-specific models (if needed)
```

## Naming Conventions

### Files
- **Screens**: `*_screen.dart` or `*_page.dart`
- **Presenters**: `*_presenter.dart`
- **UI States**: `*_ui_state.dart`
- **Use Cases**: `*_usecase.dart`
- **Repositories**: `*_repository.dart` (interface), `*_repository_impl.dart` (implementation)
- **Data Sources**: `*_data_source.dart` (interface), `*_data_source_impl.dart` (implementation)
- **Models**: `*_model.dart`
- **Entities**: `*_entity.dart`
- **Mappers**: `*_mapper.dart`

### Classes
- **Presenters**: `FeatureNamePresenter`
- **UI States**: `FeatureNameUiState`
- **Use Cases**: `FeatureNameUseCase`
- **Entities**: `FeatureNameEntity`
- **Models**: `FeatureNameModel`

## Key Patterns

### Dependency Injection
- Use `locate<T>()` to retrieve dependencies
- Register dependencies in appropriate setup modules
- Presenters are loaded with `loadPresenter<T>()`

### Error Handling
- Use `Result<T>` type (`Either<String, T>`) for error handling
- Left side contains error messages, right side contains success data
- Presenters have helper methods for handling Results

### State Management
- UI states extend `BaseUiState` with `isLoading` and `userMessage`
- Presenters extend `BasePresenter` with common functionality
- Use GetX for reactive state management

### API Integration
- All API endpoints defined in `ApiEndPoint` class
- Data sources handle API communication
- Repositories coordinate between data sources and domain layer
- Use cases contain business logic and call repositories

## Asset Organization
```
assets/
├── fonts/          # Custom fonts (Outfit family)
├── images/
│   ├── png/        # Raster images
│   └── svg/        # Vector images
```

## Configuration Files
- `pubspec.yaml` - Dependencies and asset declarations
- `analysis_options.yaml` - Dart/Flutter linting rules
- `.fvmrc` - Flutter version management
- `.env` - Environment variables