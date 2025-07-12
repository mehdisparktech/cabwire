// ignore_for_file: unused_import

import 'dart:async';
import 'dart:collection';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/services/api/api_failure.dart';
import 'package:cabwire/domain/entities/driver/payment_list_entity.dart';
import 'package:cabwire/domain/usecases/driver/get_driver_earnings_usecase.dart';
import 'package:cabwire/presentation/driver/earnings/presenter/earning_ui_state.dart';
import 'package:get/get.dart';

class EarningsPresenter extends BasePresenter<EarningsUiState> {
  final Obs<EarningsUiState> uiState = Obs<EarningsUiState>(
    EarningsUiState.initial(),
  );
  final GetDriverEarningsUseCase _getDriverEarningsUseCase;
  PaymentListEntity? _fullEarningsData;

  EarningsUiState get currentUiState => uiState.value;

  EarningsPresenter(this._getDriverEarningsUseCase) {
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
      // Fetch all earnings data once
      final result = await _getDriverEarningsUseCase.execute();

      result.fold(
        (error) {
          addUserMessage(error);
          toggleLoading(loading: false);
        },
        (success) {
          _fullEarningsData = success.data;
          // Apply filtering in the presenter
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
    final paymentData = _fullEarningsData?.data;

    if (paymentData != null && paymentData.payments != null) {
      List<PaymentEntity> filteredPayments = [];
      final now = DateTime.now();

      // Apply filter based on selected time range
      switch (filter) {
        case EarningsFilter.today:
          filteredPayments =
              paymentData.payments!
                  .where(
                    (payment) =>
                        payment.createdAt != null &&
                        _isSameDay(payment.createdAt!, now),
                  )
                  .toList();
          break;
        case EarningsFilter.week:
          filteredPayments =
              paymentData.payments!
                  .where(
                    (payment) =>
                        payment.createdAt != null &&
                        _isWithinLastDays(payment.createdAt!, now, 7),
                  )
                  .toList();
          break;
        case EarningsFilter.month:
          filteredPayments =
              paymentData.payments!
                  .where(
                    (payment) =>
                        payment.createdAt != null &&
                        _isWithinLastDays(payment.createdAt!, now, 30),
                  )
                  .toList();
          break;
      }

      // Calculate overall earnings data
      final todayEarning = _calculateTotalEarnings(filteredPayments);
      final cashPayment = _calculateCashPayments(filteredPayments);
      final onlinePayment = _calculateOnlinePayments(filteredPayments);

      // Group payments by date for daily breakdowns when week or month filter is selected
      List<DailyEarningItem> dailyEarnings = [];

      if (filter == EarningsFilter.week || filter == EarningsFilter.month) {
        // Group payments by date
        Map<String, List<PaymentEntity>> paymentsByDate = {};

        for (var payment in filteredPayments) {
          if (payment.createdAt != null) {
            final dateKey =
                "${payment.createdAt!.year}-${payment.createdAt!.month}-${payment.createdAt!.day}";
            if (!paymentsByDate.containsKey(dateKey)) {
              paymentsByDate[dateKey] = [];
            }
            paymentsByDate[dateKey]!.add(payment);
          }
        }

        // Create a DailyEarningItem for each day
        for (var entry in paymentsByDate.entries) {
          final payments = entry.value;
          if (payments.isNotEmpty && payments.first.createdAt != null) {
            dailyEarnings.add(
              DailyEarningItem(
                date: payments.first.createdAt!,
                todayEarning: _calculateTotalEarnings(payments),
                cashPayment: _calculateCashPayments(payments),
                onlinePayment: _calculateOnlinePayments(payments),
                walletAmount: 0, // Set wallet amount based on business logic
              ),
            );
          }
        }

        // Sort daily earnings by date (newest first)
        dailyEarnings.sort((a, b) => b.date.compareTo(a.date));
      }

      // Create the earnings data
      final earningsData = EarningsData(
        totalEarnings: paymentData.totalDriverAmount ?? 0,
        availableEarnings: _calculateAvailableAmount(filteredPayments),
        currentDate: DateTime.now(),
        todayEarning: todayEarning,
        cashPayment: cashPayment,
        onlinePayment: onlinePayment,
        walletAmount: 0, // Set wallet amount based on business logic
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

  double _calculateAvailableAmount(List<PaymentEntity> payments) {
    // Calculate available amount based on business logic
    double amount = 0;
    for (final payment in payments) {
      if (payment.status == 'completed' || payment.status == 'settled') {
        amount += payment.driverAmount ?? 0;
      }
    }
    return amount;
  }

  double _calculateTotalEarnings(List<PaymentEntity> payments) {
    // Calculate total earnings from the payments
    double amount = 0;
    for (final payment in payments) {
      amount += payment.driverAmount ?? 0;
    }
    return amount;
  }

  double _calculateCashPayments(List<PaymentEntity> payments) {
    // Calculate cash payments
    double amount = 0;
    for (final payment in payments) {
      if (payment.method?.toLowerCase() == 'cash') {
        amount += payment.amount ?? 0;
      }
    }
    return amount;
  }

  double _calculateOnlinePayments(List<PaymentEntity> payments) {
    // Calculate online payments
    double amount = 0;
    for (final payment in payments) {
      if (payment.method?.toLowerCase() != 'cash') {
        amount += payment.amount ?? 0;
      }
    }
    return amount;
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
      if (_fullEarningsData != null) {
        // We already have the data, just apply the new filter
        _applyFilter(selected);
      } else {
        // Fetch data again if we don't have it
        loadEarningsData(selected);
      }
    }
  }

  void withdrawAmount() {
    print("Withdraw Amount Tapped");
    addUserMessage("Withdrawal functionality not implemented yet.");
  }

  void goBack() {
    Get.back();
  }
}
