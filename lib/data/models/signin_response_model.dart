import 'package:cabwire/domain/entities/signin_response_entity.dart';

class SigninResponseModel extends SigninResponseEntity {
  const SigninResponseModel({super.message, super.success, super.data});

  factory SigninResponseModel.fromJson(Map<String, dynamic> json) {
    return SigninResponseModel(
      message: json['message'],
      success: json['success'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success, 'data': data};
  }
}
