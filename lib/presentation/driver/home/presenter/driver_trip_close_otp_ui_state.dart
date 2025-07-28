import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_request_model.dart';
import 'package:cabwire/data/models/ride_completed_response_model.dart';

class DriverTripCloseOtpUiState extends BaseUiState {
  final bool isCompleted;
  final RideRequestModel? rideResponse;
  final RideCompletedResponseModel? rideCompletedResponse;
  const DriverTripCloseOtpUiState({
    required super.isLoading,
    required super.userMessage,
    this.isCompleted = false,
    this.rideResponse,
    this.rideCompletedResponse,
  });

  static DriverTripCloseOtpUiState initial() {
    return DriverTripCloseOtpUiState(
      isLoading: false,
      userMessage: null,
      isCompleted: false,
      rideResponse: null,
      rideCompletedResponse: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isCompleted,
    rideResponse,
    rideCompletedResponse,
  ];

  DriverTripCloseOtpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isCompleted,
    RideRequestModel? rideResponse,
    RideCompletedResponseModel? rideCompletedResponse,
  }) {
    return DriverTripCloseOtpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isCompleted: isCompleted ?? this.isCompleted,
      rideResponse: rideResponse ?? this.rideResponse,
      rideCompletedResponse:
          rideCompletedResponse ?? this.rideCompletedResponse,
    );
  }
}
