import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/domain/entities/ride_entity.dart';
import 'package:cabwire/domain/repositories/ride_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:get_it/get_it.dart';

/// Parameters for the [CreateRideRequestUseCase]
class CreateRideRequestParams {
  final String service;
  final String category;
  final double pickupLat;
  final double pickupLng;
  final String pickupAddress;
  final double dropoffLat;
  final double dropoffLng;
  final String dropoffAddress;
  final String paymentMethod;

  CreateRideRequestParams({
    required this.service,
    required this.category,
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.dropoffAddress,
    required this.paymentMethod,
  });
}

/// Use case for creating a ride request
class CreateRideRequestUseCase extends BaseUseCase<void> {
  final RideRepository _repository;

  CreateRideRequestUseCase(
    this._repository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  /// Setup for service locator
  static void setupDependencies(GetIt serviceLocator) {
    if (!serviceLocator.isRegistered<CreateRideRequestUseCase>()) {
      serviceLocator.registerLazySingleton<CreateRideRequestUseCase>(
        () => CreateRideRequestUseCase(
          locate<RideRepository>(),
          locate<ErrorMessageHandler>(),
        ),
      );
    }
  }

  /// Executes the use case with the given [params]
  Future<Result<void>> execute(CreateRideRequestParams params) {
    return mapResultToEither(() async {
      // Create ride entity from params
      final rideEntity = RideEntity(
        service: params.service,
        category: params.category,
        pickupLocation: LocationEntity(
          lat: params.pickupLat,
          lng: params.pickupLng,
          address: params.pickupAddress,
        ),
        dropoffLocation: LocationEntity(
          lat: params.dropoffLat,
          lng: params.dropoffLng,
          address: params.dropoffAddress,
        ),
        paymentMethod: params.paymentMethod,
      );

      // Call repository to create ride request
      final result = await _repository.createRideRequest(rideEntity);

      // Return result or throw error
      return result.fold(
        (error) => throw Exception(error),
        (success) => success,
      );
    });
  }
}
