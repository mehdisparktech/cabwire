import 'package:cabwire/core/base/base_ui_state.dart';

class DriverStripeAccoountConnectUiState extends BaseUiState {
  const DriverStripeAccoountConnectUiState({
    required super.isLoading,
    required super.userMessage,
  });

  factory DriverStripeAccoountConnectUiState.empty() =>
      const DriverStripeAccoountConnectUiState(
        isLoading: false,
        userMessage: null,
      );

  @override
  List<Object?> get props => [isLoading, userMessage];

  DriverStripeAccoountConnectUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? resetToken,
  }) => DriverStripeAccoountConnectUiState(
    isLoading: isLoading ?? this.isLoading,
    userMessage: userMessage ?? this.userMessage,
  );
}
