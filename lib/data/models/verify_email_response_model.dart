import 'package:cabwire/domain/entities/passenger/verify_email_entity.dart';

class VerifyEmailResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  VerifyEmailResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data,
    };
  }

  VerifyEmailEntity toEntity() {
    return VerifyEmailEntity(success: success, message: message);
  }
}
