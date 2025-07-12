import 'package:cabwire/core/base/base_ui_state.dart';

class DailyEarningItem {
  final DateTime date;
  final double todayEarning;
  final double cashPayment;
  final double onlinePayment;
  final double walletAmount;

  const DailyEarningItem({
    required this.date,
    required this.todayEarning,
    required this.cashPayment,
    required this.onlinePayment,
    required this.walletAmount,
  });
}

class EarningsData {
  final double totalEarnings;
  final double availableEarnings;
  final DateTime currentDate;
  final double todayEarning;
  final double cashPayment;
  final double onlinePayment;
  final double walletAmount;
  final List<DailyEarningItem> dailyEarnings;

  const EarningsData({
    required this.totalEarnings,
    required this.availableEarnings,
    required this.currentDate,
    required this.todayEarning,
    required this.cashPayment,
    required this.onlinePayment,
    required this.walletAmount,
    this.dailyEarnings = const [],
  });
}

enum EarningsFilter { today, week, month }

class EarningsUiState extends BaseUiState {
  final EarningsData earningsData;
  final EarningsFilter selectedFilter;

  const EarningsUiState({
    required super.isLoading,
    required super.userMessage,
    required this.earningsData,
    required this.selectedFilter,
  });

  factory EarningsUiState.initial() {
    return EarningsUiState(
      isLoading: false,
      userMessage: '',
      earningsData: EarningsData(
        totalEarnings: 0,
        availableEarnings: 0,
        currentDate: DateTime.now(),
        todayEarning: 0,
        cashPayment: 0,
        onlinePayment: 0,
        walletAmount: 0,
      ),
      selectedFilter: EarningsFilter.today,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    earningsData,
    selectedFilter,
  ];

  EarningsUiState copyWith({
    bool? isLoading,
    String? userMessage,
    EarningsData? earningsData,
    EarningsFilter? selectedFilter,
  }) {
    return EarningsUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      earningsData: earningsData ?? this.earningsData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
