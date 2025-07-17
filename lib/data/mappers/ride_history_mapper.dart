import 'package:cabwire/data/models/ride/location_history_model.dart';
import 'package:cabwire/data/models/ride/ride_history_model.dart';
import 'package:cabwire/data/models/user/user_history_model.dart';
import 'package:cabwire/domain/entities/driver/ride_history_item_entity.dart';
import 'package:cabwire/domain/entities/ride/location_history_entity.dart';
import 'package:cabwire/domain/entities/ride/ride_history_entity.dart';
import 'package:cabwire/domain/entities/ride/user_history_entity.dart';

class RideHistoryMapper {
  // Map from model to domain entity
  RideHistoryEntity mapToEntity(RideHistoryModel model) {
    return RideHistoryEntity(
      id: model.id,
      pickupLocation: _mapLocationModelToEntity(model.pickupLocation),
      dropoffLocation: _mapLocationModelToEntity(model.dropoffLocation),
      user: _mapUserModelToEntity(model.userId),
      driver: _mapUserModelToEntity(model.driverId),
      service: model.service,
      category: model.category,
      distance: model.distance,
      duration: model.duration,
      fare: model.fare,
      rideStatus: model.rideStatus,
      paymentMethod: model.paymentMethod,
      paymentStatus: model.paymentStatus,
      rejectedDrivers: model.rejectedDrivers,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // Convert list of models to list of entities
  List<RideHistoryEntity> mapToEntityList(List<RideHistoryModel> models) {
    return models.map((model) => mapToEntity(model)).toList();
  }

  // Helper method to map LocationModel to LocationEntity
  LocationHistoryEntity? _mapLocationModelToEntity(
    LocationHistoryModel? model,
  ) {
    if (model == null) return null;
    return LocationHistoryEntity(
      lat: model.latitude,
      lng: model.longitude,
      address: model.address,
    );
  }

  // Helper method to map UserModel to UserEntity
  UserHistoryEntity? _mapUserModelToEntity(UserHistoryModel? model) {
    if (model == null) return null;
    return UserHistoryEntity(
      id: model.id ?? '',
      name: model.name ?? '',
      role: model.role ?? '',
      email: model.email ?? '',
      image: model.image ?? '',
      status: model.status ?? '',
      verified: model.verified ?? false,
      isOnline: model.isOnline ?? false,
      contact: model.contact,
      driverVehicles: model.driverVehicles,
    );
  }

  // Map RideEntity to RideHistoryItem (for UI presentation)
  RideHistoryItem mapToRideHistoryItem(RideHistoryEntity entity) {
    final driver = entity.driver;
    final pickupLocation = entity.pickupLocation;
    final dropoffLocation = entity.dropoffLocation;

    // Format the date for display
    final dateTime = DateTime.tryParse(entity.createdAt);
    final formattedDate =
        dateTime != null
            ? '${dateTime.day}/${dateTime.month}/${dateTime.year}'
            : '';

    // Extract vehicle info if available
    String? vehicleModel;
    String? vehicleNumber;

    if (driver?.driverVehicles != null) {
      final vehicles = driver!.driverVehicles!;
      vehicleModel =
          '${vehicles['vehiclesMake'] ?? ''} ${vehicles['vehiclesModel'] ?? ''}'
              .trim();
      vehicleNumber = vehicles['vehiclesRegistrationNumber']?.toString();
    }

    return RideHistoryItem(
      id: entity.id,
      driverName: driver?.name ?? 'Unknown Driver',
      driverLocation: '${pickupLocation?.address ?? ''} | $formattedDate',
      pickupLocation: pickupLocation?.address ?? 'Unknown pickup location',
      dropoffLocation: dropoffLocation?.address ?? 'Unknown dropoff location',
      distance: '${entity.distance.toStringAsFixed(2)} km',
      duration: '${entity.duration} Minutes',
      isCarRide: true, // Default to car ride
      vehicleNumber: vehicleNumber,
      vehicleModel: vehicleModel,
      vehicleImageUrl: null, // Would need to map this from driver vehicle data
      paymentMethod: entity.paymentMethod,
    );
  }

  // Convert list of entities to list of RideHistoryItems
  List<RideHistoryItem> mapToRideHistoryItemList(
    List<RideHistoryEntity> entities,
  ) {
    return entities.map((entity) => mapToRideHistoryItem(entity)).toList();
  }
}
