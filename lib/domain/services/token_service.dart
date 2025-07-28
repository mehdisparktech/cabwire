// token_service.dart
abstract class TokenService {
  bool get isLogIn;
  String get myNames;
  String get myEmail;
  String get myUserId;
  String get myRole;

  bool isTokenExpired();
  Map<String, dynamic> getDecodedToken();
}
