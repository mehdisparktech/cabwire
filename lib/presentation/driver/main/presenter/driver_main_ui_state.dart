import 'package:cabwire/core/base/base_ui_state.dart';

class DriverMainUiState extends BaseUiState {
  const DriverMainUiState({
    required super.isLoading,
    required super.userMessage,
    required this.selectedBottomNavIndex,
    this.lastBackPressTime,
  });

  factory DriverMainUiState.empty() {
    return DriverMainUiState(
      isLoading: false,
      userMessage: '',
      selectedBottomNavIndex: 0,
      lastBackPressTime: DateTime.now(),
    );
  }

  final int selectedBottomNavIndex;
  final DateTime? lastBackPressTime;

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    selectedBottomNavIndex,
    lastBackPressTime,
  ];

  DriverMainUiState copyWith({
    bool? isLoading,
    String? userMessage,
    int? selectedBottomNavIndex,
    DateTime? lastBackPressTime,
  }) {
    return DriverMainUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      selectedBottomNavIndex:
          selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      lastBackPressTime: lastBackPressTime ?? this.lastBackPressTime,
    );
  }
}
