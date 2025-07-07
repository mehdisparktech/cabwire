import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';

class PassengerServicesUiState extends BaseUiState {
  final List<PassengerServiceEntity> services;
  final String? error;

  const PassengerServicesUiState({
    required super.isLoading,
    required super.userMessage,
    required this.services,
    this.error,
  });

  factory PassengerServicesUiState.empty() {
    return const PassengerServicesUiState(
      userMessage: null,
      isLoading: true,
      services: [],
      error: null,
    );
  }

  @override
  List<Object?> get props => [userMessage, isLoading, services, error];

  PassengerServicesUiState copyWith({
    String? userMessage,
    bool? isLoading,
    List<PassengerServiceEntity>? services,
    String? error,
  }) {
    return PassengerServicesUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      services: services ?? this.services,
      error: error ?? this.error,
    );
  }
}
