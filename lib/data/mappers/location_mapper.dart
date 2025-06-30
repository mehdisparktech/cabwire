import 'package:cabwire/data/models/location_model.dart';
import 'package:cabwire/domain/entities/location_entity.dart';

/// Extension methods for LocationModel to convert to/from LocationEntity
extension LocationModelMapper on LocationModel {
  /// Convert model to entity
  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      address: address,
      isDefault: isDefault,
    );
  }
}

/// Extension methods for LocationEntity to convert to LocationModel
extension LocationEntityMapper on LocationEntity {
  /// Convert entity to model
  LocationModel toModel() {
    return LocationModel(
      latitude: latitude,
      longitude: longitude,
      address: address,
      isDefault: isDefault,
    );
  }
}
