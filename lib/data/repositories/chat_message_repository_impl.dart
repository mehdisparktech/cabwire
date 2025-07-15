import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/chat_message_remote_data_source.dart';
import 'package:cabwire/data/mappers/chat_message_mapper.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';
import 'package:cabwire/domain/repositories/chat_message_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatMessageRepositoryImpl implements ChatMessageRepository {
  final ChatMessageRemoteDataSource _remoteDataSource;

  ChatMessageRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ChatMessageEntity>>> getMessagesByChatId(
    String chatId,
  ) async {
    try {
      // Call the remote data source
      final result = await _remoteDataSource.getMessagesByChatId(chatId);

      // Return the result, mapping success to entity list
      return result.fold(
        (error) => left(error),
        (success) => right(ChatMessageMapper.toEntityList(success)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }
}
