import 'dart:convert';

import 'package:cabwire/domain/entities/live_trip_entity.dart';

class RidePathHistoryModel extends RidePathHistoryEntity {
  RidePathHistoryModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory RidePathHistoryModel.fromJson(Map<String, dynamic> json) {
    return RidePathHistoryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? RidePathDataModel.fromJson(json['data'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': (data as RidePathDataModel?)?.toJson(),
    };
  }
}

class RidePathDataModel extends RidePathDataEntity {
  RidePathDataModel({required super.id, required super.pathHistory});

  factory RidePathDataModel.fromJson(Map<String, dynamic> json) {
    return RidePathDataModel(
      id: json['_id'] ?? '',
      pathHistory:
          (json['pathHistory'] as List<dynamic>? ?? [])
              .map((e) => PathHistoryModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pathHistory':
          pathHistory.map((e) => (e as PathHistoryModel).toJson()).toList(),
    };
  }
}

class PathHistoryModel extends PathHistoryEntity {
  PathHistoryModel({
    required super.latitude,
    required super.longitude,
    required super.timestamp,
    required super.id,
  });

  factory PathHistoryModel.fromJson(Map<String, dynamic> json) {
    return PathHistoryModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp:
          DateTime.tryParse(json['timestamp'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      '_id': id,
    };
  }
}

RidePathHistoryModel ridePathHistoryModelFromJson(String str) =>
    RidePathHistoryModel.fromJson(json.decode(str));

String ridePathHistoryModelToJson(RidePathHistoryModel data) =>
    json.encode(data.toJson());
