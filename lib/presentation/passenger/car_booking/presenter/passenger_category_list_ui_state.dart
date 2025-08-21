import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';

class PassengerCategoryListUiState extends BaseUiState {
  final List<PassengerCategoryEntity> categories;
  final String? error;
  final PassengerCategoryEntity? selectedCategory;
  final bool isRideRequestSuccess;
  final String? selectedService;
  final double? pickupLat;
  final double? pickupLng;
  final String? pickupAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? dropoffAddress;
  final String? paymentMethod;
  final bool isFindCarLoading;
  final RideResponseModel? rideResponse;
  final String distance;
  final String duration;

  const PassengerCategoryListUiState({
    required super.isLoading,
    required super.userMessage,
    required this.categories,
    this.error,
    this.selectedCategory,
    this.isRideRequestSuccess = false,
    this.selectedService,
    this.pickupLat,
    this.pickupLng,
    this.pickupAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.dropoffAddress,
    this.paymentMethod,
    this.isFindCarLoading = false,
    this.rideResponse,
    this.distance = '',
    this.duration = '',
  });

  factory PassengerCategoryListUiState.empty() {
    return const PassengerCategoryListUiState(
      userMessage: null,
      isLoading: true,
      categories: [],
      error: null,
      selectedCategory: null,
      isRideRequestSuccess: false,
      selectedService: null,
      pickupLat: null,
      pickupLng: null,
      pickupAddress: null,
      dropoffLat: null,
      dropoffLng: null,
      dropoffAddress: null,
      paymentMethod: null,
      isFindCarLoading: false,
      rideResponse: null,
      distance: '',
      duration: '',
    );
  }

  @override
  List<Object?> get props => [
    userMessage,
    isLoading,
    categories,
    error,
    selectedCategory,
    isRideRequestSuccess,
    selectedService,
    pickupLat,
    pickupLng,
    pickupAddress,
    dropoffLat,
    dropoffLng,
    dropoffAddress,
    paymentMethod,
    isFindCarLoading,
    rideResponse,
    distance,
    duration,
  ];

  PassengerCategoryListUiState copyWith({
    bool? isLoading,
    bool? isFindCarLoading,
    String? userMessage,
    List<PassengerCategoryEntity>? categories,
    String? error,
    PassengerCategoryEntity? selectedCategory,
    bool? isRideRequestSuccess,
    String? selectedService,
    double? pickupLat,
    double? pickupLng,
    String? pickupAddress,
    double? dropoffLat,
    double? dropoffLng,
    String? dropoffAddress,
    String? paymentMethod,
    RideResponseModel? rideResponse,
    String? distance,
    String? duration,
  }) {
    return PassengerCategoryListUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      categories: categories ?? this.categories,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isRideRequestSuccess: isRideRequestSuccess ?? this.isRideRequestSuccess,
      selectedService: selectedService ?? this.selectedService,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isFindCarLoading: isFindCarLoading ?? this.isFindCarLoading,
      rideResponse: rideResponse ?? this.rideResponse,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }
}
