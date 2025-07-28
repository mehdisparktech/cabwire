import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/create_ride_model.dart';
import 'package:cabwire/data/models/ride_data_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreatePostUiState extends BaseUiState {
  const CreatePostUiState({
    required super.isLoading,
    required super.userMessage,
    this.rideData,
    this.createRideModel,
    this.totalAmount,
    this.driverName,
  });

  final RideData? rideData;
  final CreateRideModel? createRideModel;
  final String? totalAmount;
  final String? driverName;
  factory CreatePostUiState.empty() {
    // Make sure to handle the case when LocalStorage.myName might be empty
    final driverName =
        LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'Driver';

    return CreatePostUiState(
      userMessage: null,
      isLoading: true,
      rideData: RideData(
        driverName: driverName,
        vehicleNumber: 'DHK METRO HA 64-8549',
        vehicleModel: 'Volvo XC90',
        pickupLocation: '',
        dropoffLocation: '',
        totalAmount: '',
      ),
      createRideModel: CreateRideModel(
        pickupLocation: LatLng(0, 0),
        pickupAddress: '',
        destinationLocations: [],
        destinationAddresses: [],
        perKmRate: '',
        totalDistance: '',
        lastBookingTime: '',
      ),
      totalAmount: '',
      driverName: driverName,
    );
  }

  @override
  List<Object?> get props => [
    userMessage,
    isLoading,
    rideData,
    createRideModel,
    totalAmount,
    driverName,
  ];

  CreatePostUiState copyWith({
    String? userMessage,
    bool? isLoading,
    RideData? rideData,
    CreateRideModel? createRideModel,
    String? totalAmount,
    String? driverName,
  }) {
    return CreatePostUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      rideData: rideData ?? this.rideData,
      createRideModel: createRideModel ?? this.createRideModel,
      totalAmount: totalAmount ?? this.totalAmount,
      driverName: driverName ?? this.driverName,
    );
  }
}
