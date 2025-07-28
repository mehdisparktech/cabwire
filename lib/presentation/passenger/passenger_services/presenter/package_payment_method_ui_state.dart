import 'package:cabwire/core/base/base_ui_state.dart';

class PackagePaymentMethodUiState extends BaseUiState {
  final String? error;
  final bool isIWillPay;
  final bool isIWillPaySelected;
  final bool isPaymentMethodSelected;
  final String selectedPaymentMethod;

  const PackagePaymentMethodUiState({
    required super.isLoading,
    required super.userMessage,
    this.error,
    this.isIWillPay = true,
    this.isIWillPaySelected = false,
    this.isPaymentMethodSelected = false,
    this.selectedPaymentMethod = '',
  });

  factory PackagePaymentMethodUiState.empty() {
    return const PackagePaymentMethodUiState(
      isLoading: true,
      userMessage: null,
      error: null,
      isIWillPay: true,
      isIWillPaySelected: false,
      isPaymentMethodSelected: false,
      selectedPaymentMethod: '',
    );
  }
  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    error,
    isIWillPay,
    isIWillPaySelected,
    isPaymentMethodSelected,
    selectedPaymentMethod,
  ];

  PackagePaymentMethodUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? error,
    bool? isIWillPay,
    bool? isIWillPaySelected,
    bool? isPaymentMethodSelected,
    String? selectedPaymentMethod,
  }) {
    return PackagePaymentMethodUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      error: error ?? this.error,
      isIWillPay: isIWillPay ?? this.isIWillPay,
      isIWillPaySelected: isIWillPaySelected ?? this.isIWillPaySelected,
      isPaymentMethodSelected:
          isPaymentMethodSelected ?? this.isPaymentMethodSelected,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}
