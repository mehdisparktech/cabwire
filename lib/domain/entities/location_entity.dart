class LocationEntity {
  final double latitude;
  final double longitude;
  final String? address;
  final bool isDefault;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.address,
    this.isDefault = false,
  });

  /// Create a default location entity
  factory LocationEntity.defaultLocation() {
    return const LocationEntity(
      latitude: 23.8103, // Default coordinates for Dhaka, Bangladesh
      longitude: 90.4125,
      isDefault: true,
    );
  }

  @override
  String toString() =>
      'LocationEntity(latitude: $latitude, longitude: $longitude, '
      'address: $address, isDefault: $isDefault)';
}
