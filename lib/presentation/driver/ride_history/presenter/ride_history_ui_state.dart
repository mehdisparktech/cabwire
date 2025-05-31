import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/driver/ride_history_item_entity.dart';

enum RideViewMode { list, details, feedback }

class RideHistoryUiState extends BaseUiState {
  final List<RideHistoryItem> rides;
  final String? selectedRideId;
  final RideViewMode viewMode;
  final String currentFeedbackText;

  const RideHistoryUiState({
    required super.isLoading,
    required super.userMessage,
    required this.rides,
    this.selectedRideId,
    required this.viewMode,
    required this.currentFeedbackText,
  });

  factory RideHistoryUiState.initial() {
    return RideHistoryUiState(
      isLoading: false,
      userMessage: '',
      rides: [],
      selectedRideId: null,
      viewMode: RideViewMode.list,
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

  RideHistoryUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<RideHistoryItem>? rides,
    String? selectedRideId,
    bool clearSelectedRideId = false,
    RideViewMode? viewMode,
    String? currentFeedbackText,
  }) {
    return RideHistoryUiState(
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
