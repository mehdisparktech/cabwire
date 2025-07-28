class CabwireRequestEntity {
  final int seatsBooked;
  final String startTime;
  final String endTime;
  final LocationEntity pickupLocation;
  final LocationEntity dropoffLocation;
  final double distance;
  final int duration;
  final double fare;
  final int setAvailable;
  final int lastBookingTime;
  final double perKM;
  final String rideStatus;
  final String paymentMethod;
  final String paymentStatus;

  CabwireRequestEntity({
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
}

class CabwireResponseEntity {
  final bool success;
  final String message;
  final CabwireDataEntity data;

  CabwireResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}

class CabwireDataEntity {
  final String driverId;
  final LocationEntity pickupLocation;
  final LocationEntity dropoffLocation;
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

  CabwireDataEntity({
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
}

class LocationEntity {
  final double lat;
  final double lng;
  final String address;

  LocationEntity({required this.lat, required this.lng, required this.address});
}
