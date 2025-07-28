import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/chat/chat_message_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class ChatMessageRemoteDataSource {
  /// Gets all messages for a specific chat
  ///
  /// Takes a [String] chatId to identify the chat
  /// Returns a [Result<List<ChatMessageModel>>] containing the messages
  Future<Result<List<ChatMessageModel>>> getMessagesByChatId(String chatId);
}

class ChatMessageRemoteDataSourceImpl implements ChatMessageRemoteDataSource {
  final ApiService _apiService;

  ChatMessageRemoteDataSourceImpl(this._apiService);

  @override
  Future<Result<List<ChatMessageModel>>> getMessagesByChatId(
    String chatId,
  ) async {
    try {
      final response = await _apiService.get(
        '${ApiEndPoint.message}$chatId',
        header: {
          'Authorization': 'Bearer ${LocalStorage.token}',
          'Content-Type': 'application/json',
        },
      );

      return response.fold((failure) => left(failure.message), (success) {
        final List<dynamic> messagesList = success.data['data'] ?? [];
        final messages =
            messagesList
                .map((message) => ChatMessageModel.fromJson(message))
                .toList();
        return right(messages);
      });
    } catch (e) {
      return left(e.toString());
    }
  }
}
