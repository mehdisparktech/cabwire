class CompleteRideModel {
  final String rideId;
  final int otp;

  CompleteRideModel({required this.rideId, required this.otp});

  Map<String, dynamic> toJson() {
    return {'rideId': rideId, 'otp': otp};
  }
}
