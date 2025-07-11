class NotificationResponseModel {
  final bool? success;
  final String? message;
  final NotificationData? data;

  NotificationResponseModel({this.success, this.message, this.data});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? NotificationData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class NotificationData {
  final List<NotificationItem>? result;

  NotificationData({this.result});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      result:
          (json['result'] as List<dynamic>?)
              ?.map((e) => NotificationItem.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'result': result?.map((e) => e.toJson()).toList(),
  };
}

class NotificationItem {
  final String? id;
  final RideLocation? pickupLocation;
  final RideLocation? dropoffLocation;
  final bool? rideAccept;
  final bool? rideProgress;
  final String? text;
  final UserInfo? receiver;
  final bool? read;
  final UserInfo? userId;
  final double? fare;
  final double? distance;
  final int? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationItem({
    this.id,
    this.pickupLocation,
    this.dropoffLocation,
    this.rideAccept,
    this.rideProgress,
    this.text,
    this.receiver,
    this.read,
    this.userId,
    this.fare,
    this.distance,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      pickupLocation:
          json['pickupLocation'] != null
              ? RideLocation.fromJson(json['pickupLocation'])
              : null,
      dropoffLocation:
          json['dropoffLocation'] != null
              ? RideLocation.fromJson(json['dropoffLocation'])
              : null,
      rideAccept: json['rideAccept'],
      rideProgress: json['rideProgress'],
      text: json['text'],
      receiver:
          json['receiver'] != null ? UserInfo.fromJson(json['receiver']) : null,
      read: json['read'],
      userId: json['userId'] != null ? UserInfo.fromJson(json['userId']) : null,
      fare:
          (json['fare'] != null)
              ? double.tryParse(json['fare'].toString())
              : null,
      distance:
          (json['distance'] != null)
              ? double.tryParse(json['distance'].toString())
              : null,
      duration: json['duration'],
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
    'pickupLocation': pickupLocation?.toJson(),
    'dropoffLocation': dropoffLocation?.toJson(),
    'rideAccept': rideAccept,
    'rideProgress': rideProgress,
    'text': text,
    'receiver': receiver?.toJson(),
    'read': read,
    'userId': userId?.toJson(),
    'fare': fare,
    'distance': distance,
    'duration': duration,
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
      lat:
          (json['lat'] != null)
              ? double.tryParse(json['lat'].toString())
              : null,
      lng:
          (json['lng'] != null)
              ? double.tryParse(json['lng'].toString())
              : null,
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};
}

class UserInfo {
  final String? id;
  final String? name;
  final String? email;

  UserInfo({this.id, this.name, this.email});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(id: json['_id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}
