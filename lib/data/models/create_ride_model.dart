import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRideModel {
  final LatLng? pickupLocation;
  final String? pickupAddress;
  final List<LatLng>? destinationLocations;
  final List<String>? destinationAddresses;
  final String? perKmRate;
  final String? totalDistance;
  final String? lastBookingTime;

  // New fields from JSON
  final int? seatsBooked;
  final String? startTime;
  final String? endTime;
  final double? distance;
  final int? duration;
  final double? fare;
  final int? seatsAvailable;
  final int? perKM;
  final String? rideStatus;
  final String? paymentMethod;
  final String? paymentStatus;

  CreateRideModel({
    this.pickupLocation,
    this.pickupAddress,
    this.destinationLocations,
    this.destinationAddresses,
    this.perKmRate,
    this.totalDistance,
    this.lastBookingTime,
    this.seatsBooked,
    this.startTime,
    this.endTime,
    this.distance,
    this.duration,
    this.fare,
    this.seatsAvailable,
    this.perKM,
    this.rideStatus,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory CreateRideModel.fromJson(Map<String, dynamic> json) {
    return CreateRideModel(
      pickupLocation:
          json['pickupLocation'] != null
              ? LatLng(
                json['pickupLocation']['lat'] ??
                    json['pickupLocation']['latitude'],
                json['pickupLocation']['lng'] ??
                    json['pickupLocation']['longitude'],
              )
              : null,
      pickupAddress:
          json['pickupLocation'] != null
              ? json['pickupLocation']['address'] ?? json['pickupAddress']
              : null,
      destinationLocations:
          json['destinationLocations'] != null
              ? (json['destinationLocations'] as List)
                  .map(
                    (e) => LatLng(
                      e['latitude'] ?? e['lat'],
                      e['longitude'] ?? e['lng'],
                    ),
                  )
                  .toList()
              : json['dropoffLocation'] != null
              ? [
                LatLng(
                  json['dropoffLocation']['lat'],
                  json['dropoffLocation']['lng'],
                ),
              ]
              : null,
      destinationAddresses:
          json['destinationAddresses'] != null
              ? List<String>.from(json['destinationAddresses'])
              : json['dropoffLocation'] != null
              ? [json['dropoffLocation']['address']]
              : null,
      perKmRate: json['perKmRate']?.toString() ?? json['perKM']?.toString(),
      totalDistance:
          json['totalDistance']?.toString() ?? json['distance']?.toString(),
      lastBookingTime: json['lastBookingTime']?.toString(),
      seatsBooked: _parseToInt(json['seatsBooked']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      distance:
          json['distance'] != null
              ? double.tryParse(json['distance'].toString())
              : null,
      duration: _parseToInt(json['duration']),
      fare:
          json['fare'] != null
              ? double.tryParse(json['fare'].toString())
              : null,
      seatsAvailable: _parseToInt(
        json['setAvailable'] ?? json['seatsAvailable'],
      ),
      perKM: _parseToInt(json['perKM']),
      rideStatus: json['rideStatus'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (pickupLocation != null) {
      map['pickupLocation'] = {
        'lat': pickupLocation!.latitude,
        'lng': pickupLocation!.longitude,
        'address': pickupAddress,
      };
    }

    if (destinationLocations != null &&
        destinationLocations!.isNotEmpty &&
        destinationAddresses != null &&
        destinationAddresses!.isNotEmpty) {
      map['dropoffLocation'] = {
        'lat': destinationLocations![0].latitude,
        'lng': destinationLocations![0].longitude,
        'address': destinationAddresses![0],
      };

      // Also include the original format if needed
      map['destinationLocations'] =
          destinationLocations!
              .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
              .toList();
      map['destinationAddresses'] = destinationAddresses;
    }

    if (perKmRate != null) map['perKmRate'] = perKmRate;
    if (perKM != null) map['perKM'] = perKM;
    if (totalDistance != null) map['totalDistance'] = totalDistance;
    if (distance != null) map['distance'] = distance;
    if (lastBookingTime != null) map['lastBookingTime'] = lastBookingTime;
    if (seatsBooked != null) map['seatsBooked'] = seatsBooked;
    if (startTime != null) map['startTime'] = startTime;
    if (endTime != null) map['endTime'] = endTime;
    if (duration != null) map['duration'] = duration;
    if (fare != null) map['fare'] = fare;
    if (seatsAvailable != null) map['seatsAvailable'] = seatsAvailable;
    if (rideStatus != null) map['rideStatus'] = rideStatus;
    if (paymentMethod != null) map['paymentMethod'] = paymentMethod;
    if (paymentStatus != null) map['paymentStatus'] = paymentStatus;

    return map;
  }
}
