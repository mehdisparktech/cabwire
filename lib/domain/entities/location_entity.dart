import 'package:cabwire/core/base/base_entity.dart';

/// Entity representing a geographical location
class LocationEntity extends BaseEntity {
  final double latitude;
  final double longitude;
  final String? address;
  final bool isDefault;
  final double? speed; // Speed in meters per second

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.address,
    this.isDefault = false,
    this.speed, // Speed is optional
  });

  /// Create a default location entity
  factory LocationEntity.defaultLocation() {
    return const LocationEntity(
      latitude: 23.8103, // Default coordinates for Dhaka, Bangladesh
      longitude: 90.4125,
      isDefault: true,
      // No speed for default location
    );
  }

  /// Create a copy with updated values
  LocationEntity copyWith({
    double? latitude,
    double? longitude,
    String? address,
    bool? isDefault,
    double? speed,
  }) {
    return LocationEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, address, isDefault, speed];

  @override
  String toString() =>
      'LocationEntity(latitude: $latitude, longitude: $longitude, '
      'address: $address, isDefault: $isDefault, speed: $speed)';
}
