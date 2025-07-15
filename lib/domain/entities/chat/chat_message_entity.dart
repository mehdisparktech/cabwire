import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String sender;
  final String text;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatMessageEntity({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    sender,
    text,
    image,
    createdAt,
    updatedAt,
  ];
}
