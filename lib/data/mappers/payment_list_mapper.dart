import 'package:cabwire/data/models/driver/payment_list_response_model.dart';
import 'package:cabwire/domain/entities/driver/payment_list_entity.dart';

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
}
