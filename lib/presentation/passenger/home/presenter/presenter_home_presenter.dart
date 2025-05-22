import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/passenger/home/presenter/presenter_home_ui_state.dart';

class PassengerHomePresenter extends BasePresenter<HomeUiState> {
  final Obs<HomeUiState> uiState = Obs<HomeUiState>(HomeUiState.empty());
  HomeUiState get currentUiState => uiState.value;

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
