import 'package:cabwire/domain/entities/driver/create_cabwire_entity.dart';

class CabwireRequestModel {
  final int seatsBooked;
  final String startTime;
  final String endTime;
  final LocationModel pickupLocation;
  final LocationModel dropoffLocation;
  final double distance;
  final int duration;
  final double fare;
  final int setAvailable;
  final int lastBookingTime;
  final double perKM;
  final String rideStatus;
  final String paymentMethod;
  final String paymentStatus;

  CabwireRequestModel({
    required this.seatsBooked,
    required this.startTime,
    required this.endTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.setAvailable,
    required this.lastBookingTime,
    required this.perKM,
    required this.rideStatus,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'seatsBooked': seatsBooked,
      'startTime': startTime,
      'endTime': endTime,
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocation': dropoffLocation.toJson(),
      'distance': distance,
      'duration': duration,
      'fare': fare,
      'setAvailable': setAvailable,
      'lastBookingTime': lastBookingTime,
      'perKM': perKM,
      'rideStatus': rideStatus,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }

  factory CabwireRequestModel.fromEntity(CabwireRequestEntity entity) {
    return CabwireRequestModel(
      seatsBooked: entity.seatsBooked,
      startTime: entity.startTime,
      endTime: entity.endTime,
      pickupLocation: LocationModel.fromEntity(entity.pickupLocation),
      dropoffLocation: LocationModel.fromEntity(entity.dropoffLocation),
      distance: entity.distance,
      duration: entity.duration,
      fare: entity.fare,
      setAvailable: entity.setAvailable,
      lastBookingTime: entity.lastBookingTime,
      perKM: entity.perKM,
      rideStatus: entity.rideStatus,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
    );
  }

  CabwireRequestEntity toEntity() {
    return CabwireRequestEntity(
      seatsBooked: seatsBooked,
      startTime: startTime,
      endTime: endTime,
      pickupLocation: pickupLocation.toEntity(),
      dropoffLocation: dropoffLocation.toEntity(),
      distance: distance,
      duration: duration,
      fare: fare,
      setAvailable: setAvailable,
      lastBookingTime: lastBookingTime,
      perKM: perKM,
      rideStatus: rideStatus,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
    );
  }
}

class CabwireResponseModel {
  final bool success;
  final String message;
  final CabwireDataModel data;

  CabwireResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CabwireResponseModel.fromJson(Map<String, dynamic> json) {
    return CabwireResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CabwireDataModel.fromJson(json['data']),
    );
  }

  CabwireResponseEntity toEntity() {
    return CabwireResponseEntity(
      success: success,
      message: message,
      data: data.toEntity(),
    );
  }
}

class CabwireDataModel {
  final String driverId;
  final LocationModel pickupLocation;
  final LocationModel dropoffLocation;
  final double distance;
  final int duration;
  final double fare;
  final double perKM;
  final String rideStatus;
  final int setAvailable;
  final int lastBookingTime;
  final String paymentMethod;
  final String paymentStatus;
  final String id;
  final List<String> users;
  final String createdAt;
  final String updatedAt;
  final int v;

  CabwireDataModel({
    required this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.perKM,
    required this.rideStatus,
    required this.setAvailable,
    required this.lastBookingTime,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.id,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CabwireDataModel.fromJson(Map<String, dynamic> json) {
    return CabwireDataModel(
      driverId: json['driverId'] ?? '',
      pickupLocation: LocationModel.fromJson(json['pickupLocation']),
      dropoffLocation: LocationModel.fromJson(json['dropoffLocation']),
      distance: (json['distance'] ?? 0.0).toDouble(),
      duration: _parseToInt(json['duration']),
      fare: (json['fare'] ?? 0.0).toDouble(),
      perKM: (json['perKM'] ?? 0.0).toDouble(),
      rideStatus: json['rideStatus'] ?? '',
      setAvailable: _parseToInt(json['setAvailable']),
      lastBookingTime: _parseToInt(json['lastBookingTime']),
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      id: json['_id'] ?? '',
      users: List<String>.from(json['users'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: _parseToInt(json['__v']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  CabwireDataEntity toEntity() {
    return CabwireDataEntity(
      driverId: driverId,
      pickupLocation: pickupLocation.toEntity(),
      dropoffLocation: dropoffLocation.toEntity(),
      distance: distance,
      duration: duration,
      fare: fare,
      perKM: perKM,
      rideStatus: rideStatus,
      setAvailable: setAvailable,
      lastBookingTime: lastBookingTime,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      id: id,
      users: users,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
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
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'address': address};
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      lat: entity.lat,
      lng: entity.lng,
      address: entity.address,
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(lat: lat, lng: lng, address: address);
  }
}
