import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerConfirmInformationUiState extends BaseUiState {
  final String? name;
  final String? phoneNumber;

  const PassengerConfirmInformationUiState({
    required super.isLoading,
    required super.userMessage,
    this.name,
    this.phoneNumber,
  });

  factory PassengerConfirmInformationUiState.empty() {
    return const PassengerConfirmInformationUiState(
      isLoading: false,
      userMessage: null,
      name: null,
      phoneNumber: null,
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, name, phoneNumber];

  PassengerConfirmInformationUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? name,
    String? phoneNumber,
  }) {
    return PassengerConfirmInformationUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
