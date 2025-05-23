import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'passenger_profile_ui_state.dart';

class PassengerProfilePresenter extends BasePresenter<PassengerProfileUiState> {
  final Obs<PassengerProfileUiState> uiState = Obs<PassengerProfileUiState>(
    PassengerProfileUiState.empty(),
  );
  PassengerProfileUiState get currentUiState => uiState.value;

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
