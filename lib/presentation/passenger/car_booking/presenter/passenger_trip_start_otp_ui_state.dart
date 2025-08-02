import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';

class PassengerTripStartOtpUiState extends BaseUiState {
  final String? otp;
  final String? chatId;
  final String? rideId;
  final RideResponseModel? rideResponse;
  const PassengerTripStartOtpUiState({
    required super.isLoading,
    required super.userMessage,
    this.otp,
    this.chatId,
    this.rideId,
    this.rideResponse,
  });

  @override
  List<Object?> get props => [otp, chatId, rideId, rideResponse];

  factory PassengerTripStartOtpUiState.empty() {
    return PassengerTripStartOtpUiState(
      isLoading: false,
      userMessage: '',
      otp: null,
      chatId: null,
      rideId: null,
      rideResponse: null,
    );
  }

  PassengerTripStartOtpUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? otp,
    String? chatId,
    String? rideId,
    RideResponseModel? rideResponse,
  }) {
    return PassengerTripStartOtpUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      otp: otp ?? this.otp,
      chatId: chatId ?? this.chatId,
      rideId: rideId ?? this.rideId,
      rideResponse: rideResponse ?? this.rideResponse,
    );
  }
}
