import 'package:cabwire/core/base/base_entity.dart';
import 'package:cabwire/domain/entities/ride/location_history_entity.dart';
import 'package:cabwire/domain/entities/ride/user_history_entity.dart';

class RideHistoryEntity extends BaseEntity {
  final String id;
  final LocationHistoryEntity? pickupLocation;
  final LocationHistoryEntity? dropoffLocation;
  final UserHistoryEntity? user;
  final UserHistoryEntity? driver;
  final String service;
  final String category;
  final double distance;
  final int duration;
  final double fare;
  final String rideStatus;
  final String paymentMethod;
  final String paymentStatus;
  final List<String> rejectedDrivers;
  final String createdAt;
  final String updatedAt;

  const RideHistoryEntity({
    required this.id,
    this.pickupLocation,
    this.dropoffLocation,
    this.user,
    this.driver,
    required this.service,
    required this.category,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.rideStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.rejectedDrivers,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    pickupLocation,
    dropoffLocation,
    user,
    driver,
    service,
    category,
    distance,
    duration,
    fare,
    rideStatus,
    paymentMethod,
    paymentStatus,
    rejectedDrivers,
    createdAt,
    updatedAt,
  ];
}
