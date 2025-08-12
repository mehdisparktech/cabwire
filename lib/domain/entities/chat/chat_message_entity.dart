import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String? senderImage;
  final String text;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatMessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    this.senderImage,
    required this.text,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    senderName,
    senderImage,
    text,
    image,
    createdAt,
    updatedAt,
  ];
}
