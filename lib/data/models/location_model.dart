import 'package:cabwire/domain/entities/location_entity.dart';

/// Data model class for location information
///
/// Handles serialization/deserialization of location data
class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;
  final bool isDefault;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.isDefault = false,
  });

  /// Create from JSON map
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? json['lat'] ?? 0.0) as double,
      longitude: (json['longitude'] ?? json['lng'] ?? 0.0) as double,
      address: json['address'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      'isDefault': isDefault,
    };
  }

  /// Create model from entity
  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      isDefault: entity.isDefault,
    );
  }

  /// Convert model to entity
  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      address: address,
      isDefault: isDefault,
    );
  }

  /// Create a copy with updated values
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    bool? isDefault,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
