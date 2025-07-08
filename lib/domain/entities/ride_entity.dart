import 'package:cabwire/core/base/base_entity.dart';

class LocationEntity extends BaseEntity {
  final double? lat;
  final double? lng;
  final String? address;

  const LocationEntity({this.lat, this.lng, this.address});

  @override
  List<Object?> get props => [lat, lng, address];
}

class RideEntity extends BaseEntity {
  final String? userId;
  final String? service;
  final String? category;
  final LocationEntity? pickupLocation;
  final LocationEntity? dropoffLocation;
  final double? distance;
  final int? duration;
  final double? fare;
  final String? rideStatus;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? rideType;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RideEntity({
    this.userId,
    this.service,
    this.category,
    this.pickupLocation,
    this.dropoffLocation,
    this.distance,
    this.duration,
    this.fare,
    this.rideStatus,
    this.paymentMethod,
    this.paymentStatus,
    this.rideType,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    service,
    category,
    pickupLocation,
    dropoffLocation,
    distance,
    duration,
    fare,
    rideStatus,
    paymentMethod,
    paymentStatus,
    rideType,
    id,
    createdAt,
    updatedAt,
  ];

  RideEntity copyWith({
    String? userId,
    String? service,
    String? category,
    LocationEntity? pickupLocation,
    LocationEntity? dropoffLocation,
    double? distance,
    int? duration,
    double? fare,
    String? rideStatus,
    String? paymentMethod,
    String? paymentStatus,
    String? rideType,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RideEntity(
      userId: userId ?? this.userId,
      service: service ?? this.service,
      category: category ?? this.category,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      fare: fare ?? this.fare,
      rideStatus: rideStatus ?? this.rideStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      rideType: rideType ?? this.rideType,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
