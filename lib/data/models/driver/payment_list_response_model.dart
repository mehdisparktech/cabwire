class PaymentListResponseModel {
  final bool? success;
  final String? message;
  final PaymentData? data;

  PaymentListResponseModel({this.success, this.message, this.data});

  factory PaymentListResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentListResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class PaymentData {
  final double? totalDriverAmount;
  final double? totalAdminAmount;
  final List<Payment>? payments;

  PaymentData({this.totalDriverAmount, this.totalAdminAmount, this.payments});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      totalDriverAmount: (json['totalDriverAmount'] as num?)?.toDouble(),
      totalAdminAmount: (json['totalAdminAmount'] as num?)?.toDouble(),
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalDriverAmount': totalDriverAmount,
    'totalAdminAmount': totalAdminAmount,
    'payments': payments?.map((e) => e.toJson()).toList(),
  };
}

class Payment {
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

  Payment({
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

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'],
      rideId: json['rideId'],
      userId: json['userId'],
      amount: (json['amount'] as num?)?.toDouble(),
      method: json['method'],
      status: json['status'],
      transactionId: json['transactionId'],
      paidAt: json['paidAt'] != null ? DateTime.tryParse(json['paidAt']) : null,
      driverId: json['driverId'],
      adminId: json['adminId'],
      driverAmount: (json['driverAmount'] as num?)?.toDouble(),
      adminAmount: (json['adminAmount'] as num?)?.toDouble(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'rideId': rideId,
    'userId': userId,
    'amount': amount,
    'method': method,
    'status': status,
    'transactionId': transactionId,
    'paidAt': paidAt?.toIso8601String(),
    'driverId': driverId,
    'adminId': adminId,
    'driverAmount': driverAmount,
    'adminAmount': adminAmount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
