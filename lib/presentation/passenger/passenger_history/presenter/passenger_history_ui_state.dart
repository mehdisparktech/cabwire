import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/driver/entities/ride_history_item_entity.dart';

enum PassengerHistoryViewMode { list, details, feedback }

class PassengerHistoryUiState extends BaseUiState {
  final List<RideHistoryItem> rides;
  final String? selectedRideId;
  final PassengerHistoryViewMode viewMode;
  final String currentFeedbackText;

  const PassengerHistoryUiState({
    required super.isLoading,
    required super.userMessage,
    required this.rides,
    this.selectedRideId,
    required this.viewMode,
    required this.currentFeedbackText,
  });

  factory PassengerHistoryUiState.initial() {
    return PassengerHistoryUiState(
      isLoading: false,
      userMessage: '',
      rides: [],
      selectedRideId: null,
      viewMode: PassengerHistoryViewMode.list,
      currentFeedbackText: '',
    );
  }

  RideHistoryItem? get selectedRideDetails {
    if (selectedRideId == null) return null;
    try {
      return rides.firstWhere((ride) => ride.id == selectedRideId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    rides,
    selectedRideId,
    viewMode,
    currentFeedbackText,
  ];

  PassengerHistoryUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<RideHistoryItem>? rides,
    String? selectedRideId,
    bool clearSelectedRideId = false,
    PassengerHistoryViewMode? viewMode,
    String? currentFeedbackText,
  }) {
    return PassengerHistoryUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      rides: rides ?? this.rides,
      selectedRideId:
          clearSelectedRideId ? null : (selectedRideId ?? this.selectedRideId),
      viewMode: viewMode ?? this.viewMode,
      currentFeedbackText: currentFeedbackText ?? this.currentFeedbackText,
    );
  }
}
