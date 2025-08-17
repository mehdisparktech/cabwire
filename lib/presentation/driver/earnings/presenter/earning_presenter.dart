// ignore_for_file: unused_import

import 'dart:async';
import 'dart:collection';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/entities/driver/driver_earnings_entity.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:cabwire/domain/usecases/driver/get_driver_earnings_usecase.dart';
import 'package:cabwire/presentation/driver/earnings/presenter/earning_ui_state.dart';
import 'package:get/get.dart';

class EarningsPresenter extends BasePresenter<EarningsUiState> {
  final ApiService apiService;
  final Obs<EarningsUiState> uiState = Obs<EarningsUiState>(
    EarningsUiState.initial(),
  );
  final GetDriverEarningsUseCase _getDriverEarningsUseCase;
  DriverEarningsEntity? _earnings;

  EarningsUiState get currentUiState => uiState.value;

  EarningsPresenter(this._getDriverEarningsUseCase, this.apiService) {
    loadEarningsData(EarningsFilter.today);
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  Future<void> loadEarningsData(EarningsFilter filter) async {
    toggleLoading(loading: true);

    try {
      // Fetch new earnings data (total + daily)
      final result = await _getDriverEarningsUseCase.execute();

      result.fold(
        (error) {
          addUserMessage(error);
          toggleLoading(loading: false);
        },
        (success) {
          _earnings = success.data;
          _applyFilter(filter);
          toggleLoading(loading: false);
        },
      );
    } catch (e) {
      String errorMessage = 'Failed to load earnings';
      if (e is ApiFailure) {
        errorMessage = e.message;
      }
      addUserMessage(errorMessage);
      toggleLoading(loading: false);
    }
  }

  void _applyFilter(EarningsFilter filter) {
    final earnings = _earnings;

    if (earnings != null) {
      final now = DateTime.now();

      // Filter daily items by range
      List<DailyEarningEntity> filteredDaily;
      switch (filter) {
        case EarningsFilter.today:
          filteredDaily =
              earnings.daily.where((d) => _isSameDay(d.date, now)).toList();
          break;
        case EarningsFilter.week:
          filteredDaily =
              earnings.daily
                  .where((d) => _isWithinLastDays(d.date, now, 7))
                  .toList();
          break;
        case EarningsFilter.month:
          filteredDaily =
              earnings.daily
                  .where((d) => _isWithinLastDays(d.date, now, 30))
                  .toList();
          break;
      }

      // Aggregate by date (API may return multiple rows per day)
      final Map<String, DailyAgg> aggByDate = {};
      for (final d in filteredDaily) {
        final key = "${d.date.year}-${d.date.month}-${d.date.day}";
        aggByDate.putIfAbsent(
          key,
          () => DailyAgg(date: DateTime(d.date.year, d.date.month, d.date.day)),
        );
        final a = aggByDate[key]!;
        a.todayEarning += d.todayTotalEarning;
        a.cashPayment += d.cashPaymentReceived;
        a.onlinePayment += d.onlinePaymentReceived;
        a.walletAmount += d.walletAmount;
        a.available += d.todayAvailableEarning;
      }

      // Compute summary values for current filter
      double todayEarning;
      double cashPayment;
      double onlinePayment;
      double walletAmount;
      double available;
      DateTime currentDate = now;

      if (filter == EarningsFilter.today) {
        final todayKey = "${now.year}-${now.month}-${now.day}";
        final a = aggByDate[todayKey];
        todayEarning = a?.todayEarning ?? 0;
        cashPayment = a?.cashPayment ?? 0;
        onlinePayment = a?.onlinePayment ?? 0;
        walletAmount = a?.walletAmount ?? 0;
        available = a?.available ?? 0;
      } else {
        todayEarning = aggByDate.values.fold(0, (p, e) => p + e.todayEarning);
        cashPayment = aggByDate.values.fold(0, (p, e) => p + e.cashPayment);
        onlinePayment = aggByDate.values.fold(0, (p, e) => p + e.onlinePayment);
        walletAmount = aggByDate.values.fold(0, (p, e) => p + e.walletAmount);
        available = aggByDate.values.fold(0, (p, e) => p + e.available);
      }

      // Build daily list for week/month
      List<DailyEarningItem> dailyEarnings = [];
      if (filter == EarningsFilter.week || filter == EarningsFilter.month) {
        dailyEarnings =
            aggByDate.values
                .map(
                  (a) => DailyEarningItem(
                    date: a.date,
                    todayEarning: a.todayEarning,
                    cashPayment: a.cashPayment,
                    onlinePayment: a.onlinePayment,
                    walletAmount: a.walletAmount,
                  ),
                )
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));
      }

      final earningsData = EarningsData(
        totalEarnings: earnings.total.totalLifetimeEarning,
        availableEarnings: available,
        currentDate: currentDate,
        todayEarning: todayEarning,
        cashPayment: cashPayment,
        onlinePayment: onlinePayment,
        walletAmount: walletAmount,
        dailyEarnings: dailyEarnings,
      );

      uiState.value = currentUiState.copyWith(
        earningsData: earningsData,
        selectedFilter: filter,
      );
    } else {
      addUserMessage('No earnings data available');
    }
  }

  bool _isWithinLastDays(DateTime date, DateTime referenceDate, int days) {
    return referenceDate.difference(date).inDays <= days;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void onFilterSelected(String? value) {
    if (value == null) return;

    EarningsFilter selected;
    switch (value) {
      case 'today':
        selected = EarningsFilter.today;
        break;
      case 'week':
        selected = EarningsFilter.week;
        break;
      case 'month':
        selected = EarningsFilter.month;
        break;
      default:
        return;
    }
    if (selected != currentUiState.selectedFilter) {
      if (_earnings != null) {
        // We already have the data, just apply the new filter
        _applyFilter(selected);
      } else {
        // Fetch data again if we don't have it
        loadEarningsData(selected);
      }
    }
  }

  Future<void> withdrawAmount() async {
    final userId = LocalStorage.userId;
    final result = await apiService.post(ApiEndPoint.withdrawAmount + userId);
    result.fold(
      (error) {
        addUserMessage(error.message);
      },
      (success) {
        addUserMessage(success.message ?? 'Withdrawal successful');
      },
    );
  }

  void goBack() {
    Get.back();
  }
}

// Aggregation helper for daily earnings
class DailyAgg {
  final DateTime date;
  double todayEarning = 0;
  double cashPayment = 0;
  double onlinePayment = 0;
  double walletAmount = 0;
  double available = 0;
  DailyAgg({required this.date});
}
