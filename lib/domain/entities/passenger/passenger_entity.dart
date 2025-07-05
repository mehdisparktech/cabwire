import 'package:cabwire/core/base/base_entity.dart';

class PassengerEntity extends BaseEntity {
  final String? id;
  final String name;
  final String role;
  final String email;
  final String? password;
  final String? image;
  final String? status;
  final bool? verified;
  final LocationEntity? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PassengerEntity({
    this.id,
    required this.name,
    required this.role,
    required this.email,
    this.password,
    this.image,
    this.status,
    this.verified,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    email,
    password,
    image,
    status,
    verified,
    location,
    createdAt,
    updatedAt,
  ];
}

class LocationEntity extends BaseEntity {
  final double lat;
  final double lng;
  final String address;

  const LocationEntity({
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  List<Object?> get props => [lat, lng, address];
}
