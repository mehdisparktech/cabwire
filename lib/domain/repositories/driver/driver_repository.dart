import 'package:cabwire/core/base/result.dart';

abstract class DriverRepository {
  Future<Result<void>> updateOnlineStatus(String email, bool isOnline);
  Future<Result<void>> updateProfilePhoto(String email, String photo);
}
