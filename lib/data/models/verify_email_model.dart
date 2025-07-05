class VerifyEmailModel {
  final String email;
  final int oneTimeCode;

  VerifyEmailModel({required this.email, required this.oneTimeCode});

  Map<String, dynamic> toJson() {
    return {'email': email, 'oneTimeCode': oneTimeCode};
  }

  factory VerifyEmailModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailModel(
      email: json['email'] as String,
      oneTimeCode: json['oneTimeCode'] as int,
    );
  }
}
