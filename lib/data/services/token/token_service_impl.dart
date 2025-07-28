// token_service_impl.dart
import 'package:cabwire/core/utility/log/error_log.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/token_service.dart';

class TokenServiceImpl implements TokenService {
  static Map<String, dynamic>? _decodedToken;
  static TokenServiceImpl? _instance;

  // Singleton pattern
  static TokenServiceImpl get instance {
    _instance ??= TokenServiceImpl._();
    return _instance!;
  }

  TokenServiceImpl._();

  @override
  bool get isLogIn => myEmail.isNotEmpty;

  @override
  String get myNames => getDecodedToken()['fullName'] ?? "";

  @override
  String get myEmail => getDecodedToken()['email'] ?? "";

  @override
  String get myUserId => getDecodedToken()['userId'] ?? "";

  @override
  String get myRole => getDecodedToken()['role'] ?? "";

  @override
  bool isTokenExpired() {
    try {
      bool value = JwtDecoder.isExpired(LocalStorage.token);
      return value;
    } catch (e) {
      errorLog(e, source: "Token Service");
      return false;
    }
  }

  @override
  Map<String, dynamic> getDecodedToken() {
    try {
      _decodedToken ??= JwtDecoder.decode(LocalStorage.token);
      return _decodedToken!;
    } catch (e) {
      errorLog(e, source: "Token Service");
      return {};
    }
  }

  // Clear cached token when needed (e.g., logout)
  void clearToken() {
    _decodedToken = null;
  }
}
