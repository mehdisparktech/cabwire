import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/external_libs/flutter_toast/custom_toast.dart';
import 'package:cabwire/domain/usecases/complete_ride_usecase.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_trip_close_otp_ui_state.dart';
import 'package:cabwire/presentation/driver/ride_history/ui/screens/ride_details_page.dart';
import 'package:get/get.dart';

class DriverTripCloseOtpPresenter
    extends BasePresenter<DriverTripCloseOtpUiState> {
  final CompleteRideUseCase _completeRideUseCase;
  final Obs<DriverTripCloseOtpUiState> uiState = Obs<DriverTripCloseOtpUiState>(
    DriverTripCloseOtpUiState.initial(),
  );

  DriverTripCloseOtpUiState get currentUiState => uiState.value;

  DriverTripCloseOtpPresenter(this._completeRideUseCase);

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  /// Completes a ride with the provided rideId and OTP
  Future<void> completeRide(String rideId, int otp) async {
    toggleLoading(loading: true);
    final params = CompleteRideParams(rideId: rideId, otp: otp);
    final result = await _completeRideUseCase(params);

    result.fold(
      (error) {
        uiState.value = currentUiState.copyWith(
          userMessage: error,
          isCompleted: false,
        );
        CustomToast(message: error, duration: const Duration(seconds: 2));
        toggleLoading(loading: false);
      },
      (success) {
        uiState.value = currentUiState.copyWith(
          userMessage: null,
          isCompleted: true,
        );
        CustomToast(
          message: success.message,
          duration: const Duration(seconds: 2),
        );
        Get.offAll(() => RideDetailsScreen());
        toggleLoading(loading: false);
      },
    );
  }
}
