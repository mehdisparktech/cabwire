import 'package:cabwire/core/base/base_ui_state.dart';

class StripeAccountConnectUiState extends BaseUiState {
  const StripeAccountConnectUiState({required super.isLoading, required super.userMessage});

  factory StripeAccountConnectUiState.empty() {
    return const StripeAccountConnectUiState(isLoading: false, userMessage: '');
  }

  @override
  List<Object?> get props => [isLoading, userMessage];

  StripeAccountConnectUiState copyWith({
    bool? isLoading,
    String? userMessage,
  }) {
    return StripeAccountConnectUiState(isLoading: isLoading ?? this.isLoading, userMessage: userMessage ?? this.userMessage,);
  }
}