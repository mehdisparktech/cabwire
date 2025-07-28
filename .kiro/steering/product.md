# Product Overview

**Cabwire** is a taxi booking mobile application built with Flutter that connects passengers with drivers for ride-hailing services.

## Core Features

- **Dual User Types**: Supports both passenger and driver interfaces
- **Ride Booking**: Passengers can book rides with service type and category selection
- **Real-time Communication**: Chat functionality between passengers and drivers
- **Location Services**: GPS-based pickup and dropoff location handling
- **Payment Integration**: Multiple payment method support
- **Ride History**: Track and view past rides
- **Notifications**: Real-time push notifications for ride updates
- **Profile Management**: User profile and account management

## Architecture

The app follows **Clean Architecture** principles with clear separation between:
- **Domain Layer**: Business logic and entities
- **Data Layer**: API communication and data persistence
- **Presentation Layer**: UI components and state management

## Key Technologies

- Flutter framework for cross-platform mobile development
- Firebase for backend services (Firestore, Analytics, Messaging)
- Socket.IO for real-time communication
- Google Maps integration for location services
- GetX for state management and dependency injection