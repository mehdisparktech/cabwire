import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/notification_response_model.dart';

class NotificationUiState extends BaseUiState {
  const NotificationUiState({
    required super.isLoading,
    required super.userMessage,
    this.notifications,
  });

  final List<NotificationResponseModel>? notifications;

  factory NotificationUiState.empty() {
    return NotificationUiState(
      userMessage: null,
      isLoading: true,
      notifications: [],
    );
  }

  @override
  List<Object?> get props => [userMessage, isLoading, notifications];

  NotificationUiState copyWith({
    String? userMessage,
    bool? isLoading,
    List<NotificationResponseModel>? notifications,
  }) {
    return NotificationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      notifications: notifications ?? this.notifications,
    );
  }
}
