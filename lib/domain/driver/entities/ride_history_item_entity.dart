import 'package:cabwire/core/base/base_entity.dart';

class RideHistoryItem extends BaseEntity {
  final String id;
  final String driverName;
  final String driverLocation; // This could be date/time for the list item
  final String pickupLocation;
  final String dropoffLocation;
  final String distance;
  final String duration;
  final bool isCarRide;

  // Detailed information - populated when details are fetched or available
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? vehicleImageUrl;
  final String? paymentMethod;
  final String? existingFeedback;
  // Add any other detail-specific fields here, e.g., exact fare, map polyline data

  const RideHistoryItem({
    required this.id,
    required this.driverName,
    required this.driverLocation, // For list view, might show date/time
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.duration,
    required this.isCarRide,
    this.vehicleNumber,
    this.vehicleModel,
    this.vehicleImageUrl,
    this.paymentMethod,
    this.existingFeedback,
  });

  // copyWith is essential for updating the item with details
  RideHistoryItem copyWith({
    String? id,
    String? driverName,
    String? driverLocation,
    String? pickupLocation,
    String? dropoffLocation,
    String? distance,
    String? duration,
    bool? isCarRide,
    String? vehicleNumber,
    String? vehicleModel,
    String? vehicleImageUrl,
    String? paymentMethod,
    String? existingFeedback,
    bool clearDetails = false,
  }) {
    return RideHistoryItem(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      driverLocation: driverLocation ?? this.driverLocation,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      isCarRide: isCarRide ?? this.isCarRide,
      vehicleNumber:
          clearDetails ? null : (vehicleNumber ?? this.vehicleNumber),
      vehicleModel: clearDetails ? null : (vehicleModel ?? this.vehicleModel),
      vehicleImageUrl:
          clearDetails ? null : (vehicleImageUrl ?? this.vehicleImageUrl),
      paymentMethod:
          clearDetails ? null : (paymentMethod ?? this.paymentMethod),
      existingFeedback:
          clearDetails ? null : (existingFeedback ?? this.existingFeedback),
    );
  }

  @override
  List<Object?> get props => [
    id,
    driverName,
    driverLocation,
    pickupLocation,
    dropoffLocation,
    distance,
    duration,
  ];
}
