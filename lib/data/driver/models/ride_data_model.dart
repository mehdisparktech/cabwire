import 'package:cabwire/data/driver/models/trip_statistic_model.dart';

class RideData {
  final String driverName;
  final String vehicleNumber;
  final String vehicleModel;
  final String pickupLocation;
  final String dropoffLocation;
  final String? dropoffLocation2;
  final List<TripStatistic>? statistics;
  final String totalAmount;

  const RideData({
    required this.driverName,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.dropoffLocation2,
    this.statistics,
    required this.totalAmount,
  });
}
