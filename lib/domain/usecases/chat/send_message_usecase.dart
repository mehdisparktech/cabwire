import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';
import 'package:cabwire/domain/repositories/send_message_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:equatable/equatable.dart';

/// Parameters for the [SendMessageUseCase]
class SendMessageParams extends Equatable {
  final String chatId;
  final String text;
  final String? imagePath;

  const SendMessageParams({
    required this.chatId,
    required this.text,
    this.imagePath,
  });

  @override
  List<Object?> get props => [chatId, text, imagePath];
}

/// Use case for sending a message with optional image
class SendMessageUseCase extends BaseUseCase<ChatMessageEntity> {
  final SendMessageRepository _repository;

  SendMessageUseCase(this._repository, ErrorMessageHandler errorMessageHandler)
    : super(errorMessageHandler);

  /// Executes the use case to send a message
  ///
  /// Takes [SendMessageParams] containing the chat ID, text, and optional image path
  /// Returns a [Result<ChatMessageEntity>] containing the created message
  Future<Result<ChatMessageEntity>> execute(SendMessageParams params) {
    return mapResultToEither(() async {
      // Call repository to send message
      final result = await _repository.sendMessage(
        chatId: params.chatId,
        text: params.text,
        imagePath: params.imagePath,
      );

      // Return result or throw error
      return result.fold(
        (error) => throw Exception(error),
        (success) => success,
      );
    });
  }
}
