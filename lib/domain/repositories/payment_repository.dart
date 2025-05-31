import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  /// Get all bank payments
  Stream<Either<String, List<BankPaymentEntity>>> getBankPaymentsStream();

  /// Get all mobile payments
  Stream<Either<String, List<MobilePaymentEntity>>> getMobilePaymentsStream();
}
