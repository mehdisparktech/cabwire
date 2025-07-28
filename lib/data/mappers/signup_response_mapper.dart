import 'package:cabwire/data/models/signup_response_model.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';

extension SignupResponseMapper on SignupResponseModel {
  SignupResponseEntity toEntity() {
    return SignupResponseEntity(
      success: success,
      message: message,
      data: UserDataEntity(
        name: data?.name,
        role: data?.role,
        email: data?.email,
        password: data?.password,
        image: data?.image,
        status: data?.status,
        verified: data?.verified,
        isOnline: data?.isOnline,
        isDeleted: data?.isDeleted,
        id: data?.id,
        createdAt: data?.createdAt,
      ),
    );
  }
}
