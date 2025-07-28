import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_services_usecase.dart';
import 'passenger_services_ui_state.dart';

class PassengerServicesPresenter
    extends BasePresenter<PassengerServicesUiState> {
  final GetPassengerServicesUseCase _getPassengerServicesUseCase;
  final Obs<PassengerServicesUiState> uiState = Obs<PassengerServicesUiState>(
    PassengerServicesUiState.empty(),
  );
  PassengerServicesUiState get currentUiState => uiState.value;

  PassengerServicesPresenter(this._getPassengerServicesUseCase);

  @override
  void onInit() {
    super.onInit();
    loadPassengerServices();
  }

  Future<void> loadPassengerServices() async {
    try {
      toggleLoading(loading: true);
      final result = await _getPassengerServicesUseCase();

      result.fold(
        (failure) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            error: failure.message,
          );
          addUserMessage(failure.message);
        },
        (services) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            services: services,
            error: null,
          );
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      addUserMessage(e.toString());
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
