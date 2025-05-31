import 'package:cabwire/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.address,
    super.isDefault = false,
  });

  /// Create from a map (for handling JSON data)
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String?,
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  /// Convert to a map (for storing data)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isDefault': isDefault,
    };
  }

  /// Create from a location entity
  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      isDefault: entity.isDefault,
    );
  }
}
