import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_services/presenter/package_payment_method_ui_state.dart';

class PackagePaymentMethodPresenter
    extends BasePresenter<PackagePaymentMethodUiState> {
  final Obs<PackagePaymentMethodUiState> uiState =
      Obs<PackagePaymentMethodUiState>(PackagePaymentMethodUiState.empty());
  PackagePaymentMethodUiState get currentUiState => uiState.value;

  PackagePaymentMethodPresenter();

  void onIWillPayChanged(bool value) {
    uiState.value = currentUiState.copyWith(isIWillPaySelected: value);
  }

  void onPaymentMethodSelected(String methodTitle) {
    uiState.value = currentUiState.copyWith(
      isPaymentMethodSelected: true,
      selectedPaymentMethod: methodTitle,
    );
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
