import 'package:fpdart/fpdart.dart';
import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/domain/user/entities/payment_entity.dart';
import 'package:cabwire/domain/user/repositories/payment_repository.dart';
import 'package:cabwire/domain/user/service/error_message_handler.dart';

class GetBankPaymentsUseCase extends BaseUseCase<List<BankPaymentEntity>> {
  final PaymentRepository _paymentRepository;

  GetBankPaymentsUseCase(
    this._paymentRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Stream<Either<String, List<BankPaymentEntity>>> execute() {
    return _paymentRepository.getBankPaymentsStream();
  }
}
