import 'package:fpdart/fpdart.dart';

abstract class ShareService {
  Future<Either<String, void>> shareText(String text);
  Future<Either<String, void>> shareToWhatsApp(String text);
  Future<Either<String, void>> shareToMessenger(String text);
  Future<Either<String, void>> shareViaEmail(String subject, String body);
  String generateTripShareLink(String rideId);
}
