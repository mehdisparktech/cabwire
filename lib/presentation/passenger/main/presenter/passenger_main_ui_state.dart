import 'package:cabwire/core/base/base_ui_state.dart';

class PassengerMainUiState extends BaseUiState {
  const PassengerMainUiState({
    required super.isLoading,
    required super.userMessage,
    required this.selectedBottomNavIndex,
    this.lastBackPressTime,
  });

  factory PassengerMainUiState.empty() {
    return PassengerMainUiState(
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

  PassengerMainUiState copyWith({
    bool? isLoading,
    String? userMessage,
    int? selectedBottomNavIndex,
    DateTime? lastBackPressTime,
  }) {
    return PassengerMainUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      selectedBottomNavIndex:
          selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      lastBackPressTime: lastBackPressTime ?? this.lastBackPressTime,
    );
  }
}
