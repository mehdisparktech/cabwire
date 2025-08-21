import 'package:cabwire/data/models/ride/create_ride_request_model.dart'
    as request;
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/entities/ride_entity.dart';

/// Mapper class for transforming between domain entities and data models
class RideMapper {
  /// Maps RideEntity to CreateRideRequestModel
  static request.CreateRideRequestModel toRequestModel(RideEntity entity) {
    return request.CreateRideRequestModel(
      service: entity.service!,
      category: entity.category!,
      pickupLocation: request.LocationModel(
        lat: entity.pickupLocation!.lat!,
        lng: entity.pickupLocation!.lng!,
        address: entity.pickupLocation!.address!,
      ),
      dropoffLocation: request.LocationModel(
        lat: entity.dropoffLocation!.lat!,
        lng: entity.dropoffLocation!.lng!,
        address: entity.dropoffLocation!.address!,
      ),
      duration: entity.duration!,
      distance: entity.distance!,
      paymentMethod: entity.paymentMethod!,
    );
  }

  /// Maps RideResponseModel to RideEntity
  static RideEntity fromResponseModel(RideResponseModel model) {
    return model.data.toEntity();
  }
}
