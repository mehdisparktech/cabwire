import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';

class DriverTripStartOtpUiState extends BaseUiState {
  final String? otp;
  final String? chatId;
  final String? rideId;
  final RideResponseModel? rideResponse;
  const DriverTripStartOtpUiState({
    required super.isLoading,
    required super.userMessage,
    this.otp,
    this.chatId,
    this.rideId,
    this.rideResponse,
  });

  @override
  List<Object?> get props => [otp, chatId, rideId, rideResponse];

  factory DriverTripStartOtpUiState.empty() {
    return DriverTripStartOtpUiState(
      isLoading: false,
      userMessage: '',
      otp: null,
      chatId: null,
      rideId: null,
      rideResponse: null,
    );
  }

  DriverTripStartOtpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? otp,
    String? chatId,
    String? rideId,
    RideResponseModel? rideResponse,
  }) {
    return DriverTripStartOtpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      otp: otp ?? this.otp,
      chatId: chatId ?? this.chatId,
      rideId: rideId ?? this.rideId,
      rideResponse: rideResponse ?? this.rideResponse,
    );
  }
}
