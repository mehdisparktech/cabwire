import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/driver/create_cabwire_entity.dart';
import 'package:cabwire/domain/repositories/driver/create_cabwire_repository.dart';
import 'package:cabwire/data/models/create_ride_model.dart';

class CreateCabwireUsecase {
  final CreateCabwireRepository repository;

  CreateCabwireUsecase(this.repository);

  Future<Result<CabwireResponseEntity>> execute(
    CreateRideModel rideModel,
    double fare,
  ) async {
    // Create the request entity from the ride model
    final request = _createRequestFromRideModel(rideModel, fare);
    return await repository.createCabwire(request);
  }

  CabwireRequestEntity _createRequestFromRideModel(
    CreateRideModel model,
    double fare,
  ) {
    // Get current date for start time
    final now = DateTime.now();
    final startTime = now.toIso8601String();

    // Add 1 hour for end time
    final endTime = now.add(const Duration(hours: 1)).toIso8601String();

    // Create pickup location
    final pickupLocation = LocationEntity(
      lat: model.pickupLocation.latitude,
      lng: model.pickupLocation.longitude,
      address: model.pickupAddress,
    );

    // Create dropoff location (using first destination if available)
    final dropoffLocation = LocationEntity(
      lat:
          model.destinationLocations.isNotEmpty
              ? model.destinationLocations.first.latitude
              : 0.0,
      lng:
          model.destinationLocations.isNotEmpty
              ? model.destinationLocations.first.longitude
              : 0.0,
      address:
          model.destinationAddresses.isNotEmpty
              ? model.destinationAddresses.first
              : '',
    );

    // Calculate distance from the total distance string
    final distance = double.tryParse(model.totalDistance) ?? 15.5;

    // Use the perKmRate as perKM
    final perKM = double.tryParse(model.perKmRate) ?? 20;

    // Parse the lastBookingTime or use current timestamp
    final lastBookingTime =
        int.tryParse(model.lastBookingTime) ??
        (DateTime.now().millisecondsSinceEpoch ~/ 1000);

    // Duration is roughly distance * 2 minutes per km
    final duration = (distance * 2).round();

    return CabwireRequestEntity(
      seatsBooked: 2,
      startTime: startTime,
      endTime: endTime,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      distance: distance,
      duration: duration,
      fare: fare,
      setAvailable: 16,
      lastBookingTime: lastBookingTime,
      perKM: perKM,
      rideStatus: "requested",
      paymentMethod: "stripe",
      paymentStatus: "pending",
    );
  }
}
