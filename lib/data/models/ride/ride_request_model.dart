import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequestModel {
  final String id;
  final String userId;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final double fare;
  final double distance;
  final int duration;
  final String createdAt;

  RideRequestModel({
    required this.id,
    required this.userId,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.fare,
    required this.distance,
    required this.duration,
    required this.createdAt,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    // Extract nested location data
    final pickupLoc = json['pickupLocation'] as Map<String, dynamic>? ?? {};
    final dropoffLoc = json['dropoffLocation'] as Map<String, dynamic>? ?? {};

    return RideRequestModel(
      id: json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      pickupLocation: LatLng(
        pickupLoc['lat'] as double? ?? 0.0,
        pickupLoc['lng'] as double? ?? 0.0,
      ),
      pickupAddress: pickupLoc['address'] as String? ?? 'Unknown location',
      dropoffLocation: LatLng(
        dropoffLoc['lat'] as double? ?? 0.0,
        dropoffLoc['lng'] as double? ?? 0.0,
      ),
      dropoffAddress: dropoffLoc['address'] as String? ?? 'Unknown location',
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
