import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/ride_entity.dart';
import 'package:cabwire/domain/repositories/ride_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';

/// Parameters for the [CreateRideRequestUseCase]
class CreateRideRequestParams {
  final String service;
  final String category;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> dropoffLocation;
  final int duration;
  final String paymentMethod;

  CreateRideRequestParams({
    required this.service,
    required this.category,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.duration,
    required this.paymentMethod,
  });
}

/// Use case for creating a ride request
class CreateRideRequestUseCase extends BaseUseCase<RideResponseModel> {
  final RideRepository _repository;

  CreateRideRequestUseCase(
    this._repository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  /// Setup for service locator
  // static void setupDependencies(GetIt serviceLocator) {
  //   if (!serviceLocator.isRegistered<CreateRideRequestUseCase>()) {
  //     serviceLocator.registerLazySingleton<CreateRideRequestUseCase>(
  //       () => CreateRideRequestUseCase(
  //         locate<RideRepository>(),
  //         locate<ErrorMessageHandler>(),
  //       ),
  //     );
  //   }
  // }

  /// Executes the use case with the given [params]
  Future<Result<RideResponseModel>> execute(CreateRideRequestParams params) {
    return mapResultToEither(() async {
      // Create ride entity from params
      final rideEntity = RideEntity(
        service: params.service,
        category: params.category,
        pickupLocation: LocationEntity(
          lat: params.pickupLocation['lat'],
          lng: params.pickupLocation['lng'],
          address: params.pickupLocation['address'],
        ),
        dropoffLocation: LocationEntity(
          lat: params.dropoffLocation['lat'],
          lng: params.dropoffLocation['lng'],
          address: params.dropoffLocation['address'],
        ),
        duration: params.duration,
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
