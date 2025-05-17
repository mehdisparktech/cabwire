import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'ride_history_ui_state.dart';

class RideHistoryPresenter extends BasePresenter<RideHistoryUiState> {
  final Obs<RideHistoryUiState> uiState = Obs<RideHistoryUiState>(RideHistoryUiState.empty());
  RideHistoryUiState get currentUiState => uiState.value;

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
