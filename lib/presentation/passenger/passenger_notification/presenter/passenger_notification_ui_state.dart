import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/data/models/notification_response_model.dart';

class PassengerNotificationUiState extends BaseUiState {
  const PassengerNotificationUiState({
    required super.isLoading,
    required super.userMessage,
    this.notifications,
  });

  final List<NotificationResponseModel>? notifications;

  factory PassengerNotificationUiState.empty() {
    return PassengerNotificationUiState(
      userMessage: null,
      isLoading: true,
      notifications: [],
    );
  }

  @override
  List<Object?> get props => [userMessage, isLoading, notifications];

  PassengerNotificationUiState copyWith({
    String? userMessage,
    bool? isLoading,
    List<NotificationResponseModel>? notifications,
  }) {
    return PassengerNotificationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      notifications: notifications ?? this.notifications,
    );
  }
}
