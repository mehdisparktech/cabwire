import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';

class PassengerHomeUiState extends BaseUiState {
  final List<PassengerServiceEntity> services;
  final String? error;
  final PassengerCategoryEntity? selectedCategory;
  const PassengerHomeUiState({
    required super.isLoading,
    required super.userMessage,
    required this.services,
    this.error,
    this.selectedCategory,
  });

  factory PassengerHomeUiState.empty() {
    return PassengerHomeUiState(
      isLoading: false,
      userMessage: '',
      services: [],
      error: null,
      selectedCategory: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    services,
    error,
    selectedCategory,
  ];

  PassengerHomeUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<PassengerServiceEntity>? services,
    String? error,
    PassengerCategoryEntity? selectedCategory,
  }) {
    return PassengerHomeUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      services: services ?? this.services,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
