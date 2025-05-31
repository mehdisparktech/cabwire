import 'package:cabwire/domain/service/error_message_handler.dart';

class ErrorMessageHandlerImpl implements ErrorMessageHandler {
  @override
  String generateErrorMessage(Object error) {
    if (error is FormatException) {
      return 'Data format is not correct';
    }

    return error.toString();
  }
}
