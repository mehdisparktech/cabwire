import 'package:cabwire/data/models/signin_response_model.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';

extension SigninResponseMapper on SigninResponseModel {
  SigninResponseEntity toEntity() {
    return SigninResponseEntity(message: message, success: success, data: data);
  }
}
