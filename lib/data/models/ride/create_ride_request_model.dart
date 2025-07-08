class LocationModel {
  final double lat;
  final double lng;
  final String address;

  const LocationModel({
    required this.lat,
    required this.lng,
    required this.address,
  });

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};
}

class CreateRideRequestModel {
  final String service;
  final String category;
  final LocationModel pickupLocation;
  final LocationModel dropoffLocation;
  final String paymentMethod;

  const CreateRideRequestModel({
    required this.service,
    required this.category,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
    'service': service,
    'category': category,
    'pickupLocation': pickupLocation.toJson(),
    'dropoffLocation': dropoffLocation.toJson(),
    'paymentMethod': paymentMethod,
  };
}
