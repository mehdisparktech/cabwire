import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/contact_us_entity.dart';

abstract class DriverProfileRepository {
  Future<Result<void>> submitContactForm(ContactUsEntity contactUs);
}
