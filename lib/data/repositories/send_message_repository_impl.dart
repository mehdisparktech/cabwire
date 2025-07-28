import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/send_message_remote_data_source.dart';
import 'package:cabwire/data/mappers/chat_message_mapper.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';
import 'package:cabwire/domain/repositories/send_message_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageRepositoryImpl implements SendMessageRepository {
  final SendMessageRemoteDataSource _remoteDataSource;

  SendMessageRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ChatMessageEntity>> sendMessage({
    required String chatId,
    required String text,
    String? imagePath,
  }) async {
    try {
      // Call the remote data source
      final result = await _remoteDataSource.sendMessage(
        chatId: chatId,
        text: text,
        imagePath: imagePath,
      );

      // Return the result, mapping success to entity
      return result.fold(
        (error) => left(error),
        (success) => right(ChatMessageMapper.toEntity(success)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
