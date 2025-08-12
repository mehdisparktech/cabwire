import 'package:cabwire/data/models/chat/chat_message_model.dart';
import 'package:cabwire/domain/entities/chat/chat_message_entity.dart';

class ChatMessageMapper {
  static ChatMessageEntity toEntity(ChatMessageModel model) {
    return ChatMessageEntity(
      id: model.id,
      chatId: model.chatId,
      senderId: model.senderId,
      senderName: model.senderName,
      senderImage: model.senderImage,
      text: model.text,
      image: model.image,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static ChatMessageModel toModel(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderImage: entity.senderImage,
      text: entity.text,
      image: entity.image,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ChatMessageEntity> toEntityList(List<ChatMessageModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  static List<ChatMessageModel> toModelList(List<ChatMessageEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
