import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/notifications_usecase.dart';
import 'passenger_notification_ui_state.dart';

class PassengerNotificationPresenter
    extends BasePresenter<PassengerNotificationUiState> {
  final NotificationsUseCase _notificationsUseCase;
  final Obs<PassengerNotificationUiState> uiState =
      Obs<PassengerNotificationUiState>(PassengerNotificationUiState.empty());
  PassengerNotificationUiState get currentUiState => uiState.value;

  PassengerNotificationPresenter(this._notificationsUseCase);

  Future<void> getNotifications() async {
    try {
      toggleLoading(loading: true);
      final result = await _notificationsUseCase.execute();
      uiState.value = currentUiState.copyWith(notifications: result);
    } catch (e) {
      addUserMessage(e.toString());
    } finally {
      toggleLoading(loading: false);
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
