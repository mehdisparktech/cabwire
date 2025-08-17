import 'package:cabwire/data/models/driver/payment_list_response_model.dart';
import 'package:cabwire/domain/entities/driver/payment_list_entity.dart';
import 'package:cabwire/data/models/driver/driver_earnings_models.dart';
import 'package:cabwire/domain/entities/driver/driver_earnings_entity.dart';

class PaymentListMapper {
  static PaymentListEntity toEntity(PaymentListResponseModel model) {
    return PaymentListEntity(
      success: model.success,
      message: model.message,
      data: model.data != null ? _toPaymentDataEntity(model.data!) : null,
    );
  }

  static PaymentDataEntity _toPaymentDataEntity(PaymentData model) {
    return PaymentDataEntity(
      totalDriverAmount: model.totalDriverAmount,
      totalAdminAmount: model.totalAdminAmount,
      payments:
          model.payments?.map((payment) => _toPaymentEntity(payment)).toList(),
    );
  }

  static PaymentEntity _toPaymentEntity(Payment model) {
    return PaymentEntity(
      id: model.id,
      rideId: model.rideId,
      userId: model.userId,
      amount: model.amount,
      method: model.method,
      status: model.status,
      transactionId: model.transactionId,
      paidAt: model.paidAt,
      driverId: model.driverId,
      adminId: model.adminId,
      driverAmount: model.driverAmount,
      adminAmount: model.adminAmount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // New helpers to map new endpoints to domain
  static DriverEarningsEntity toDriverEarningsEntity({
    required TotalEarningResponseModel total,
    required DailyEarningResponseModel daily,
  }) {
    return DriverEarningsEntity(
      total: TotalEarningsEntity(
        totalLifetimeEarning: total.data.totalLifetimeEarning,
        totalLifetimeCashPayment: total.data.totalLifetimeCashPayment,
        totalLifetimeOnlinePayment: total.data.totalLifetimeOnlinePayment,
        totalLifetimeWalletAmount: total.data.totalLifetimeWalletAmount,
      ),
      daily:
          daily.data
              .map(
                (e) => DailyEarningEntity(
                  date: e.date,
                  isTransferredToDriver: e.isTransferdToDriver,
                  adminDueAmount: e.adminDueAmount,
                  cashPaymentReceived: e.cashPaymentReceived,
                  onlinePaymentReceived: e.onlinePaymentReceived,
                  todayAvailableEarning: e.todayAvailableEarning,
                  todayTotalEarning: e.todayTotalEarning,
                  walletAmount: e.walletAmount,
                ),
              )
              .toList(),
    );
  }
}
