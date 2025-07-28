class ChatMessageModel {
  final String id;
  final String chatId;
  final String sender;
  final String text;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      image: json['image'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'sender': sender,
      'text': text,
      if (image != null) 'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
