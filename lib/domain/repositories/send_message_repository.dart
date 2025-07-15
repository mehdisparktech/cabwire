import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';

/// Interface for the Send Message repository
abstract class SendMessageRepository {
  /// Sends a message with optional image
  ///
  /// Takes [chatId], [text], and optional [imagePath]
  /// Returns a [Result<ChatMessageEntity>] with the created message
  Future<Result<ChatMessageEntity>> sendMessage({
    required String chatId,
    required String text,
    String? imagePath,
  });
}
