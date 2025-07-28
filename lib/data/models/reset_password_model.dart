class ResetPasswordModel {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class ResetPasswordResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  ResetPasswordResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }
}
