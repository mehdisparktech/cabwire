import 'package:cabwire/core/base/base_entity.dart';

class DriverEarningsEntity extends BaseEntity {
  final TotalEarningsEntity total;
  final List<DailyEarningEntity> daily;

  const DriverEarningsEntity({required this.total, required this.daily});

  @override
  List<Object?> get props => [total, daily];
}

class TotalEarningsEntity extends BaseEntity {
  final double totalLifetimeEarning;
  final double totalLifetimeCashPayment;
  final double totalLifetimeOnlinePayment;
  final double totalLifetimeWalletAmount;

  const TotalEarningsEntity({
    required this.totalLifetimeEarning,
    required this.totalLifetimeCashPayment,
    required this.totalLifetimeOnlinePayment,
    required this.totalLifetimeWalletAmount,
  });

  @override
  List<Object?> get props => [
    totalLifetimeEarning,
    totalLifetimeCashPayment,
    totalLifetimeOnlinePayment,
    totalLifetimeWalletAmount,
  ];
}

class DailyEarningEntity extends BaseEntity {
  final DateTime date;
  final bool isTransferredToDriver;
  final double adminDueAmount;
  final double cashPaymentReceived;
  final double onlinePaymentReceived;
  final double todayAvailableEarning;
  final double todayTotalEarning;
  final double walletAmount;

  const DailyEarningEntity({
    required this.date,
    required this.isTransferredToDriver,
    required this.adminDueAmount,
    required this.cashPaymentReceived,
    required this.onlinePaymentReceived,
    required this.todayAvailableEarning,
    required this.todayTotalEarning,
    required this.walletAmount,
  });

  @override
  List<Object?> get props => [
    date,
    isTransferredToDriver,
    adminDueAmount,
    cashPaymentReceived,
    onlinePaymentReceived,
    todayAvailableEarning,
    todayTotalEarning,
    walletAmount,
  ];
}
