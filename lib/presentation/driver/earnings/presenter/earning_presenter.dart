// ignore_for_file: unused_import

import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/earnings/presenter/earning_ui_state.dart';
import 'package:get/get.dart';

class EarningsPresenter extends BasePresenter<EarningsUiState> {
  final Obs<EarningsUiState> uiState = Obs<EarningsUiState>(
    EarningsUiState.initial(),
  );
  EarningsUiState get currentUiState => uiState.value;

  EarningsPresenter() {
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
    await Future.delayed(const Duration(seconds: 1));

    EarningsData data;
    switch (filter) {
      case EarningsFilter.today:
        data = EarningsData(
          totalEarnings: 22458.50,
          availableEarnings: 2458.50,
          currentDate: DateTime(2025, 5, 6),
          todayEarning: 2300.25,
          cashPayment: 1500.0,
          onlinePayment: 800.25,
          walletAmount: 200.0,
        );
        break;
      case EarningsFilter.week:
        data = EarningsData(
          totalEarnings: 35000.00,
          availableEarnings: 5000.00,
          currentDate: DateTime(2025, 5, 6),
          todayEarning: 7000.00,
          cashPayment: 4000.0,
          onlinePayment: 3000.00,
          walletAmount: 150.0,
        );
        break;
      case EarningsFilter.month:
        data = EarningsData(
          totalEarnings: 120000.00,
          availableEarnings: 15000.00,
          currentDate: DateTime(2025, 5, 6),
          todayEarning: 25000.00,
          cashPayment: 18000.0,
          onlinePayment: 7000.00,
          walletAmount: -50.0,
        );
        break;
    }

    uiState.value = currentUiState.copyWith(
      isLoading: false,
      earningsData: data,
      selectedFilter: filter,
    );
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
      loadEarningsData(selected);
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
