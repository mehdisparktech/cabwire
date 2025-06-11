import 'package:cabwire/domain/usecases/driver/resent_code_usecase.dart';

class DriverResendCodeHandler {
  final ResentCodeUsecase resentCodeUsecase;

  DriverResendCodeHandler({required this.resentCodeUsecase});

  Future<void> resendCode({
    required String email,
    required Future<void> Function(String message) showMessage,
    required Future<void> Function(String message) addUserMessage,
  }) async {
    final result = await resentCodeUsecase.execute(email.trim());

    result.fold(
      (errorMessage) async => await addUserMessage(errorMessage),
      (message) async => await addUserMessage(message),
    );

    await showMessage(result.fold((l) => l, (r) => r));
  }
}
