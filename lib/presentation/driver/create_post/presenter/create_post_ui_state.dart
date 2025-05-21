import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/driver/models/ride_data_model.dart';

class CreatePostUiState extends BaseUiState {
  const CreatePostUiState({
    required super.isLoading,
    required super.userMessage,
    this.rideData,
  });

  final RideData? rideData;

  factory CreatePostUiState.empty() {
    return const CreatePostUiState(
      userMessage: null,
      isLoading: true,
      rideData: RideData(
        driverName: 'Santiago Dslab',
        vehicleNumber: 'DHK METRO HA 64-8549',
        vehicleModel: 'Volvo XC90',
        pickupLocation: 'Block B, Banasree, Dhaka.',
        dropoffLocation: 'Green Road, Dhanmondi, Dhaka.',
        totalAmount: '\$100',
      ),
    );
  }

  @override
  List<Object?> get props => [userMessage, isLoading, rideData];

  CreatePostUiState copyWith({
    String? userMessage,
    bool? isLoading,
    RideData? rideData,
  }) {
    return CreatePostUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      rideData: rideData ?? this.rideData,
    );
  }
}
