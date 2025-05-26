import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'car_booking_ui_state.dart';

class CarBookingPresenter extends BasePresenter<CarBookingUiState> {
  final Obs<CarBookingUiState> uiState = Obs<CarBookingUiState>(CarBookingUiState.empty());
  CarBookingUiState get currentUiState => uiState.value;

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
