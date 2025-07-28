class RideCompletedResponseModel {
  final bool? success;
  final String? message;
  final RideData? data;

  RideCompletedResponseModel({this.success, this.message, this.data});

  factory RideCompletedResponseModel.fromJson(Map<String, dynamic> json) {
    return RideCompletedResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? RideData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class RideData {
  final String? id;
  final String? userId;
  final String? driverId;
  final String? service;
  final String? category;
  final RideLocation? pickupLocation;
  final RideLocation? dropoffLocation;
  final double? distance;
  final int? duration;
  final double? fare;
  final String? rideStatus;
  final String? paymentMethod;
  final String? paymentStatus;
  final List<dynamic>? rejectedDrivers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RideData({
    this.id,
    this.userId,
    this.driverId,
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
    this.rejectedDrivers,
    this.createdAt,
    this.updatedAt,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      id: json['_id'],
      userId: json['userId'],
      driverId: json['driverId'],
      service: json['service'],
      category: json['category'],
      pickupLocation:
          json['pickupLocation'] != null
              ? RideLocation.fromJson(json['pickupLocation'])
              : null,
      dropoffLocation:
          json['dropoffLocation'] != null
              ? RideLocation.fromJson(json['dropoffLocation'])
              : null,
      distance: (json['distance'] as num?)?.toDouble(),
      duration: json['duration'],
      fare: (json['fare'] as num?)?.toDouble(),
      rideStatus: json['rideStatus'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      rejectedDrivers: json['rejectedDrivers'] ?? [],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'driverId': driverId,
    'service': service,
    'category': category,
    'pickupLocation': pickupLocation?.toJson(),
    'dropoffLocation': dropoffLocation?.toJson(),
    'distance': distance,
    'duration': duration,
    'fare': fare,
    'rideStatus': rideStatus,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'rejectedDrivers': rejectedDrivers,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class RideLocation {
  final double? lat;
  final double? lng;
  final String? address;

  RideLocation({this.lat, this.lng, this.address});

  factory RideLocation.fromJson(Map<String, dynamic> json) {
    return RideLocation(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};
}
