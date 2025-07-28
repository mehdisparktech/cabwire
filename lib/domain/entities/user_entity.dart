import 'package:cabwire/core/base/base_entity.dart';

class UserEntity extends BaseEntity {
  final String? name;
  final String? email;
  final String? role;
  final String? password;

  const UserEntity({this.name, this.email, this.role, this.password});

  @override
  List<Object?> get props => [name, email, role, password];
}
