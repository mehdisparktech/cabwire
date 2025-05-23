import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'passenger_notification_ui_state.dart';

class PassengerNotificationPresenter
    extends BasePresenter<PassengerNotificationUiState> {
  final Obs<PassengerNotificationUiState> uiState =
      Obs<PassengerNotificationUiState>(PassengerNotificationUiState.empty());
  PassengerNotificationUiState get currentUiState => uiState.value;

  PassengerNotificationPresenter();

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
