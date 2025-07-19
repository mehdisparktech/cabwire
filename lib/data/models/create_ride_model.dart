import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRideModel {
  final LatLng pickupLocation;
  final String pickupAddress;
  final List<LatLng> destinationLocations;
  final List<String> destinationAddresses;
  final String perKmRate;
  final String totalDistance;
  final String lastBookingTime;

  CreateRideModel({
    required this.pickupLocation,
    required this.pickupAddress,
    required this.destinationLocations,
    required this.destinationAddresses,
    required this.perKmRate,
    required this.totalDistance,
    required this.lastBookingTime,
  });

  factory CreateRideModel.fromJson(Map<String, dynamic> json) {
    return CreateRideModel(
      pickupLocation: LatLng(
        json['pickupLocation']['latitude'],
        json['pickupLocation']['longitude'],
      ),
      pickupAddress: json['pickupAddress'],
      destinationLocations:
          json['destinationLocations']
              .map((e) => LatLng(e['latitude'], e['longitude']))
              .toList(),
      destinationAddresses: json['destinationAddresses'],
      perKmRate: json['perKmRate'],
      totalDistance: json['totalDistance'],
      lastBookingTime: json['lastBookingTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation.toJson(),
      'pickupAddress': pickupAddress,
      'destinationLocations':
          destinationLocations.map((e) => e.toJson()).toList(),
      'destinationAddresses': destinationAddresses,
      'perKmRate': perKmRate,
      'totalDistance': totalDistance.toString(),
      'lastBookingTime': lastBookingTime.toString(),
    };
  }
}
