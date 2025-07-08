import 'package:cabwire/core/base/base_ui_state.dart';

class CarBookingUiState extends BaseUiState {
  final String? errorMessage;
  final bool isRideRequestSuccess;

  const CarBookingUiState({
    super.isLoading = false,
    super.userMessage,
    this.errorMessage,
    this.isRideRequestSuccess = false,
  });

  factory CarBookingUiState.empty() => const CarBookingUiState();

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    errorMessage,
    isRideRequestSuccess,
  ];

  CarBookingUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? errorMessage,
    bool? isRideRequestSuccess,
  }) {
    return CarBookingUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isRideRequestSuccess: isRideRequestSuccess ?? this.isRideRequestSuccess,
    );
  }
}
