import 'package:cabwire/data/models/ride/location_history_model.dart';
import 'package:cabwire/data/models/user/user_history_model.dart';

class RideHistoryModel {
  final String id;
  final LocationHistoryModel? pickupLocation;
  final LocationHistoryModel? dropoffLocation;
  final UserHistoryModel? userId;
  final UserHistoryModel? driverId;
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

  RideHistoryModel({
    required this.id,
    this.pickupLocation,
    this.dropoffLocation,
    this.userId,
    this.driverId,
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

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryModel(
      id: json['_id'] ?? '',
      pickupLocation:
          json['pickupLocation'] != null
              ? LocationHistoryModel.fromJson(json['pickupLocation'])
              : null,
      dropoffLocation:
          json['dropoffLocation'] != null
              ? LocationHistoryModel.fromJson(json['dropoffLocation'])
              : null,
      userId:
          json['userId'] != null
              ? UserHistoryModel.fromJson(json['userId'])
              : null,
      driverId:
          json['driverId'] != null
              ? UserHistoryModel.fromJson(json['driverId'])
              : null,
      service: json['service'] ?? '',
      category: json['category'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      fare: (json['fare'] ?? 0).toDouble(),
      rideStatus: json['rideStatus'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      rejectedDrivers:
          json['rejectedDrivers'] != null
              ? List<String>.from(json['rejectedDrivers'])
              : [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
