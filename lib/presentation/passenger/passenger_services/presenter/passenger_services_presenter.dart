import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'passenger_services_ui_state.dart';

class PassengerServicesPresenter
    extends BasePresenter<PassengerServicesUiState> {
  final Obs<PassengerServicesUiState> uiState = Obs<PassengerServicesUiState>(
    PassengerServicesUiState.empty(),
  );
  PassengerServicesUiState get currentUiState => uiState.value;

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
