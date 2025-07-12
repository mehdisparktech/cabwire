import 'package:cabwire/core/base/base_entity.dart';

class PaymentListEntity extends BaseEntity {
  final bool? success;
  final String? message;
  final PaymentDataEntity? data;

  const PaymentListEntity({this.success, this.message, this.data});

  @override
  List<Object?> get props => [success, message, data];
}

class PaymentDataEntity extends BaseEntity {
  final double? totalDriverAmount;
  final double? totalAdminAmount;
  final List<PaymentEntity>? payments;

  const PaymentDataEntity({
    this.totalDriverAmount,
    this.totalAdminAmount,
    this.payments,
  });

  @override
  List<Object?> get props => [totalDriverAmount, totalAdminAmount, payments];
}

class PaymentEntity extends BaseEntity {
  final String? id;
  final String? rideId;
  final String? userId;
  final double? amount;
  final String? method;
  final String? status;
  final String? transactionId;
  final DateTime? paidAt;
  final String? driverId;
  final String? adminId;
  final double? driverAmount;
  final double? adminAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentEntity({
    this.id,
    this.rideId,
    this.userId,
    this.amount,
    this.method,
    this.status,
    this.transactionId,
    this.paidAt,
    this.driverId,
    this.adminId,
    this.driverAmount,
    this.adminAmount,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    rideId,
    userId,
    amount,
    method,
    status,
    transactionId,
    paidAt,
    driverId,
    adminId,
    driverAmount,
    adminAmount,
    createdAt,
    updatedAt,
  ];
}
