import 'package:cabwire/domain/entities/ride_entity.dart';

class RideResponseModel {
  final bool success;
  final String message;
  final RideDataModel data;

  RideResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RideResponseModel.fromJson(Map<String, dynamic> json) {
    return RideResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RideDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class LocationModel {
  final double lat;
  final double lng;
  final String address;

  LocationModel({required this.lat, required this.lng, required this.address});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};

  LocationEntity toEntity() {
    return LocationEntity(lat: lat, lng: lng, address: address);
  }
}

class RideDataModel {
  final String userId;
  final String service;
  final String category;
  final LocationModel pickupLocation;
  final LocationModel dropoffLocation;
  final double distance;
  final int duration;
  final double fare;
  final String rideStatus;
  final String paymentMethod;
  final String paymentStatus;
  final String? rideType;
  final String id;
  final String createdAt;
  final String updatedAt;

  RideDataModel({
    required this.userId,
    required this.service,
    required this.category,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.rideStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.rideType,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RideDataModel.fromJson(Map<String, dynamic> json) {
    return RideDataModel(
      userId: json['userId'] as String,
      service: json['service'] as String,
      category: json['category'] as String,
      pickupLocation: LocationModel.fromJson(
        json['pickupLocation'] as Map<String, dynamic>,
      ),
      dropoffLocation: LocationModel.fromJson(
        json['dropoffLocation'] as Map<String, dynamic>,
      ),
      distance: (json['distance'] as num).toDouble(),
      duration: json['duration'] as int,
      fare: (json['fare'] as num).toDouble(),
      rideStatus: json['rideStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      rideType: json['rideType'] as String?,
      id: json['_id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  RideEntity toEntity() {
    return RideEntity(
      userId: userId,
      service: service,
      category: category,
      pickupLocation: pickupLocation.toEntity(),
      dropoffLocation: dropoffLocation.toEntity(),
      distance: distance,
      duration: duration,
      fare: fare,
      rideStatus: rideStatus,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      rideType: rideType,
      id: id,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
