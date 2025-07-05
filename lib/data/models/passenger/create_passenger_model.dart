class CreatePassengerModel {
  final String name;
  final String role;
  final String email;
  final String password;

  CreatePassengerModel({
    required this.name,
    required this.role,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'role': role, 'email': email, 'password': password};
  }
}
