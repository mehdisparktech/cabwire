import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'notification_ui_state.dart';

class NotificationPresenter extends BasePresenter<NotificationUiState> {
  final Obs<NotificationUiState> uiState = Obs<NotificationUiState>(NotificationUiState.empty());
  NotificationUiState get currentUiState => uiState.value;

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
