import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final String? image;
  final String? status;
  final bool? verified;
  final bool? isOnline;
  final bool? isDeleted;
  final GeoLocationEntity? geoLocation;
  final String? stripeAccountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileEntity({
    this.id,
    this.name,
    this.role,
    this.email,
    this.image,
    this.status,
    this.verified,
    this.isOnline,
    this.isDeleted,
    this.geoLocation,
    this.stripeAccountId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    email,
    image,
    status,
    verified,
    isOnline,
    isDeleted,
    geoLocation,
    stripeAccountId,
    createdAt,
    updatedAt,
  ];
}

class GeoLocationEntity extends Equatable {
  final String? type;
  final List<double>? coordinates;

  const GeoLocationEntity({this.type, this.coordinates});

  @override
  List<Object?> get props => [type, coordinates];
}
