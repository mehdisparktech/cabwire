import 'package:cabwire/domain/entities/ride/location_history_entity.dart';

/// Data model class for location information
///
/// Handles serialization/deserialization of location data
class LocationHistoryModel {
  final double latitude;
  final double longitude;
  final String address;

  LocationHistoryModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory LocationHistoryModel.fromJson(Map<String, dynamic> json) {
    return LocationHistoryModel(
      latitude: (json['lat'] ?? 0.0).toDouble(),
      longitude: (json['lng'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address};
  }

  /// Create model from entity
  factory LocationHistoryModel.fromEntity(LocationHistoryEntity entity) {
    return LocationHistoryModel(
      latitude: entity.lat,
      longitude: entity.lng,
      address: entity.address,
    );
  }

  /// Convert model to entity
  LocationHistoryEntity toEntity() {
    return LocationHistoryEntity(
      lat: latitude,
      lng: longitude,
      address: address,
    );
  }

  /// Create a copy with updated values
  LocationHistoryModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationHistoryModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}
