import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'driver_profile_ui_state.dart';

class DriverProfilePresenter extends BasePresenter<DriverProfileUiState> {
  final Obs<DriverProfileUiState> uiState = Obs<DriverProfileUiState>(
    DriverProfileUiState.empty(),
  );
  DriverProfileUiState get currentUiState => uiState.value;

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
