import 'package:cabwire/domain/services/share_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareServiceImpl implements ShareService {
  @override
  Future<Either<String, void>> shareText(String text) async {
    try {
      await Share.share(text);
      return const Right(null);
    } catch (e) {
      return Left('Failed to share: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> shareToWhatsApp(String text) async {
    try {
      final whatsappUrl = Uri.parse(
        'whatsapp://send?text=${Uri.encodeComponent(text)}',
      );
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
        return const Right(null);
      } else {
        // Fallback to regular share if WhatsApp is not installed
        return await shareText(text);
      }
    } catch (e) {
      return Left('Failed to share to WhatsApp: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> shareToMessenger(String text) async {
    try {
      final messengerUrl = Uri.parse(
        'fb-messenger://share?text=${Uri.encodeComponent(text)}',
      );
      if (await canLaunchUrl(messengerUrl)) {
        await launchUrl(messengerUrl);
        return const Right(null);
      } else {
        // Fallback to regular share if Messenger is not installed
        return await shareText(text);
      }
    } catch (e) {
      return Left('Failed to share to Messenger: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> shareViaEmail(
    String subject,
    String body,
  ) async {
    try {
      final emailUrl = Uri.parse(
        'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );
      if (await canLaunchUrl(emailUrl)) {
        await launchUrl(emailUrl);
        return const Right(null);
      } else {
        return const Left('No email app available');
      }
    } catch (e) {
      return Left('Failed to share via email: ${e.toString()}');
    }
  }

  @override
  String generateTripShareLink(String rideId) {
    // Generate deep link for the trip using custom scheme
    // This will directly open the app instead of browser
    return 'https://www.cabwire.com/live-trip/$rideId';
  }
}
