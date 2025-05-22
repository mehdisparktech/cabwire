class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final bool isVerified;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.isVerified,
  });

  factory AuthUser.empty() {
    return AuthUser(id: '', email: '', name: '', isVerified: false);
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    bool? isVerified,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
