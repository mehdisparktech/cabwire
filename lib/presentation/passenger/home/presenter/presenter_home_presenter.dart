import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_services_usecase.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_ui_state.dart';

class PassengerHomePresenter extends BasePresenter<PassengerHomeUiState> {
  final GetPassengerServicesUseCase _getPassengerServicesUseCase;
  final Obs<PassengerHomeUiState> uiState = Obs<PassengerHomeUiState>(
    PassengerHomeUiState.empty(),
  );
  PassengerHomeUiState get currentUiState => uiState.value;

  PassengerHomePresenter(this._getPassengerServicesUseCase);
  @override
  void onInit() {
    super.onInit();
    loadPassengerServices();
  }

  Future<void> loadPassengerServices() async {
    try {
      await toggleLoading(loading: true);
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
