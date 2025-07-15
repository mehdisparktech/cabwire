import 'package:cabwire/core/base/base_use_case.dart';
import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';
import 'package:cabwire/domain/repositories/chat_message_repository.dart';
import 'package:cabwire/domain/services/error_message_handler.dart';
import 'package:equatable/equatable.dart';

/// Parameters for the [GetMessagesByChatIdUseCase]
class GetMessagesByChatIdParams extends Equatable {
  final String chatId;

  const GetMessagesByChatIdParams({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

/// Use case for getting messages by chat ID
class GetMessagesByChatIdUseCase extends BaseUseCase<List<ChatMessageEntity>> {
  final ChatMessageRepository _repository;

  GetMessagesByChatIdUseCase(
    this._repository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  /// Executes the use case to get messages by chat ID
  ///
  /// Takes [GetMessagesByChatIdParams] containing the chat ID
  /// Returns a [Result<List<ChatMessageEntity>>] containing the messages
  Future<Result<List<ChatMessageEntity>>> execute(
    GetMessagesByChatIdParams params,
  ) {
    return mapResultToEither(() async {
      // Call repository to get messages
      final result = await _repository.getMessagesByChatId(params.chatId);

      // Return result or throw error
      return result.fold(
        (error) => throw Exception(error),
        (success) => success,
      );
    });
  }
}
