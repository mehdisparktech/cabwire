class DailyEarningResponseModel {
  final bool success;
  final String message;
  final List<DailyEarningItemModel> data;

  DailyEarningResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DailyEarningResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> raw = (json['data'] as List<dynamic>? ?? []);
    return DailyEarningResponseModel(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: raw.map((e) => DailyEarningItemModel.fromJson(e)).toList(),
    );
  }
}

class DailyEarningItemModel {
  final String id;
  final bool isTransferdToDriver;
  final DateTime date;
  final double adminDueAmount;
  final double cashPaymentReceived;
  final double onlinePaymentReceived;
  final double todayAvailableEarning;
  final double todayTotalEarning;
  final double walletAmount;

  DailyEarningItemModel({
    required this.id,
    required this.isTransferdToDriver,
    required this.date,
    required this.adminDueAmount,
    required this.cashPaymentReceived,
    required this.onlinePaymentReceived,
    required this.todayAvailableEarning,
    required this.todayTotalEarning,
    required this.walletAmount,
  });

  factory DailyEarningItemModel.fromJson(Map<String, dynamic> json) {
    return DailyEarningItemModel(
      id: json['_id'] ?? '',
      isTransferdToDriver: json['isTransferred'] == true,
      date: DateTime.tryParse(json['_id'] ?? '') ?? DateTime.now(),
      adminDueAmount: (json['adminDueAmount'] as num?)?.toDouble() ?? 0,
      cashPaymentReceived:
          (json['totalCashPayment'] as num?)?.toDouble() ?? 0,
      onlinePaymentReceived:
          (json['totalOnlinePayment'] as num?)?.toDouble() ?? 0,
      todayAvailableEarning:
          (json['todayAvailableEarning'] as num?)?.toDouble() ?? 0,
      todayTotalEarning: (json['totalEarning'] as num?)?.toDouble() ?? 0,
      walletAmount: (json['totalWalletAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TotalEarningResponseModel {
  final bool success;
  final String message;
  final TotalEarningModel data;

  TotalEarningResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TotalEarningResponseModel.fromJson(Map<String, dynamic> json) {
    return TotalEarningResponseModel(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: TotalEarningModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class TotalEarningModel {
  final double totalLifetimeEarning;
  final double totalLifetimeCashPayment;
  final double totalLifetimeOnlinePayment;
  final double totalLifetimeWalletAmount;

  TotalEarningModel({
    required this.totalLifetimeEarning,
    required this.totalLifetimeCashPayment,
    required this.totalLifetimeOnlinePayment,
    required this.totalLifetimeWalletAmount,
  });

  factory TotalEarningModel.fromJson(Map<String, dynamic> json) {
    return TotalEarningModel(
      totalLifetimeEarning:
          (json['totalLifetimeEarning'] as num?)?.toDouble() ?? 0,
      totalLifetimeCashPayment:
          (json['totalLifetimeCashPayment'] as num?)?.toDouble() ?? 0,
      totalLifetimeOnlinePayment:
          (json['totalLifetimeOnlinePayment'] as num?)?.toDouble() ?? 0,
      totalLifetimeWalletAmount:
          (json['totalLifetimeWalletAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}
