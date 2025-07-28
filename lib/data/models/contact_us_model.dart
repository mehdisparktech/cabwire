import 'package:cabwire/domain/entities/contact_us_entity.dart';

class ContactUsModel extends ContactUsEntity {
  const ContactUsModel({
    required super.fullName,
    required super.email,
    super.phone,
    required super.subject,
    required super.description,
    required super.status,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      subject: json['subject'] as String,
      description: json['description'] as String,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      if (phone != null) 'phone': phone,
      'subject': subject,
      'description': description,
      'status': status,
    };
  }
}

class ContactUsResponseModel {
  final bool success;
  final String message;
  final ContactUsModel? data;

  ContactUsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ContactUsResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactUsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? ContactUsModel.fromJson(json['data']) : null,
    );
  }
}
