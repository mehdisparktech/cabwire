import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/driver/notification_entity.dart';

class PassengerNotificationUiState extends BaseUiState {
  const PassengerNotificationUiState({
    required super.isLoading,
    required super.userMessage,
    this.notifications,
  });

  final List<NotificationEntity>? notifications;

  factory PassengerNotificationUiState.empty() {
    return PassengerNotificationUiState(
      userMessage: null,
      isLoading: true,
      notifications: [
        NotificationEntity(
          title: 'Payment Successful',
          description: 'Payment successfully processed. Thank you!',
          image: 'image1',
          time: '1h',
        ),
        NotificationEntity(
          title: 'New Ride Request',
          description:
              'A new ride request has been received. Please accept or reject it.',
          image: 'image2',
          time: '1h',
        ),
      ],
    );
  }

  @override
  List<Object?> get props => [userMessage, isLoading, notifications];

  PassengerNotificationUiState copyWith({
    String? userMessage,
    bool? isLoading,
    List<NotificationEntity>? notifications,
  }) {
    return PassengerNotificationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      notifications: notifications ?? this.notifications,
    );
  }
}
