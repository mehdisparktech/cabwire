import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/chat/chat_message_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class SendMessageRemoteDataSource {
  /// Sends a message with optional image
  ///
  /// Takes [chatId], [text], and optional [imagePath]
  /// Returns a [Result<ChatMessageModel>] with the created message
  Future<Result<ChatMessageModel>> sendMessage({
    required String chatId,
    required String text,
    String? imagePath,
  });
}

class SendMessageRemoteDataSourceImpl implements SendMessageRemoteDataSource {
  final ApiService _apiService;

  SendMessageRemoteDataSourceImpl(this._apiService);

  @override
  Future<Result<ChatMessageModel>> sendMessage({
    required String chatId,
    required String text,
    String? imagePath,
  }) async {
    try {
      // Create body parameters
      final Map<String, String> body = {'chatId': chatId, 'text': text};

      // Call API service to send message with multipart request if image is provided
      final response = await _apiService.multipart(
        ApiEndPoint.message,
        header: {'Authorization': 'Bearer ${LocalStorage.token}'},
        body: body,
        imageName: 'image',
        imagePath: imagePath,
      );

      return response.fold((failure) => left(failure.message), (success) {
        if (success.data['success'] == true) {
          final messageData = success.data['data'];
          return right(ChatMessageModel.fromJson(messageData));
        } else {
          return left(success.data['message'] ?? 'Failed to send message');
        }
      });
    } catch (e) {
      return left(e.toString());
    }
  }
}
