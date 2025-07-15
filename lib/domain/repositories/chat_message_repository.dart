import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';

/// Interface for the Chat Message repository
abstract class ChatMessageRepository {
  /// Gets all messages for a specific chat
  ///
  /// Takes a [String] chatId to identify the chat
  /// Returns a [Result<List<ChatMessageEntity>>] containing the messages
  Future<Result<List<ChatMessageEntity>>> getMessagesByChatId(String chatId);
}
