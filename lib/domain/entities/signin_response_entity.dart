import 'package:cabwire/core/base/base_entity.dart';

class SigninResponseEntity extends BaseEntity {
  final String? message;
  final bool? success;
  final Data? data;

  const SigninResponseEntity({this.message, this.success, this.data});

  @override
  List<Object?> get props => [message, success, data];
}

class Data {
  final String? token;

  const Data({this.token});
}
