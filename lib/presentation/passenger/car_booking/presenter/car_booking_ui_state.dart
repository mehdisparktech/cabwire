import 'package:cabwire/core/base/base_ui_state.dart';

class CarBookingUiState extends BaseUiState {
  final String? errorMessage;
  final bool isRideRequestSuccess;
  final String? selectedService;
  final String? selectedCategory;
  final double? pickupLat;
  final double? pickupLng;
  final String? pickupAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? dropoffAddress;
  final String? paymentMethod;

  const CarBookingUiState({
    super.isLoading = false,
    super.userMessage,
    this.errorMessage,
    this.isRideRequestSuccess = false,
    this.selectedService,
    this.selectedCategory,
    this.pickupLat,
    this.pickupLng,
    this.pickupAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.dropoffAddress,
    this.paymentMethod,
  });

  factory CarBookingUiState.empty() => const CarBookingUiState();

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    errorMessage,
    isRideRequestSuccess,
    selectedService,
    selectedCategory,
    pickupLat,
    pickupLng,
    pickupAddress,
    dropoffLat,
    dropoffLng,
    dropoffAddress,
    paymentMethod,
  ];

  CarBookingUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? errorMessage,
    bool? isRideRequestSuccess,
    String? selectedService,
    String? selectedCategory,
    double? pickupLat,
    double? pickupLng,
    String? pickupAddress,
    double? dropoffLat,
    double? dropoffLng,
    String? dropoffAddress,
    String? paymentMethod,
  }) {
    return CarBookingUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isRideRequestSuccess: isRideRequestSuccess ?? this.isRideRequestSuccess,
      selectedService: selectedService ?? this.selectedService,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
