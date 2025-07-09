import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/domain/usecases/complete_ride_usecase.dart';
import 'package:cabwire/presentation/driver/home/presenter/driver_trip_close_otp_ui_state.dart';

class DriverTripCloseOtpPresenter
    extends BasePresenter<DriverTripCloseOtpUiState> {
  final CompleteRideUseCase _completeRideUseCase;
  final Obs<DriverTripCloseOtpUiState> _state = Obs<DriverTripCloseOtpUiState>(
    DriverTripCloseOtpUiState.initial(),
  );

  DriverTripCloseOtpUiState get state => _state.value;

  DriverTripCloseOtpPresenter(this._completeRideUseCase);

  void _emit(DriverTripCloseOtpUiState state) {
    _state.value = state;
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    _emit(state.copyWith(isLoading: loading));
  }

  @override
  Future<void> addUserMessage(String message) async {
    _emit(state.copyWith(userMessage: message));
  }

  /// Completes a ride with the provided rideId and OTP
  Future<void> completeRide(String rideId, int otp) async {
    _emit(state.copyWith(isLoading: true, userMessage: null));

    final params = CompleteRideParams(rideId: rideId, otp: otp);
    final result = await _completeRideUseCase(params);

    result.fold(
      (error) => _emit(
        state.copyWith(
          isLoading: false,
          userMessage: error,
          isCompleted: false,
        ),
      ),
      (_) => _emit(
        state.copyWith(isLoading: false, userMessage: null, isCompleted: true),
      ),
    );
  }
}
