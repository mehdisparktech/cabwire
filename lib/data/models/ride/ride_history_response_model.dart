import 'package:cabwire/data/models/ride/ride_history_model.dart';

class RideHistoryResponseModel {
  final bool success;
  final String message;
  final List<RideHistoryModel> data;

  RideHistoryResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RideHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];

    return RideHistoryResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList.map((item) => RideHistoryModel.fromJson(item)).toList(),
    );
  }
}
