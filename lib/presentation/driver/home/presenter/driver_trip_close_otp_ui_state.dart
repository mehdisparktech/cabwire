import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';

class DriverTripCloseOtpUiState extends BaseUiState {
  final bool isCompleted;
  final RideRequestModel? rideResponse;

  const DriverTripCloseOtpUiState({
    required super.isLoading,
    required super.userMessage,
    this.isCompleted = false,
    this.rideResponse,
  });

  static DriverTripCloseOtpUiState initial() {
    return DriverTripCloseOtpUiState(
      isLoading: false,
      userMessage: null,
      isCompleted: false,
      rideResponse: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isCompleted,
    rideResponse,
  ];

  DriverTripCloseOtpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isCompleted,
    RideRequestModel? rideResponse,
  }) {
    return DriverTripCloseOtpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isCompleted: isCompleted ?? this.isCompleted,
      rideResponse: rideResponse ?? this.rideResponse,
    );
  }
}
