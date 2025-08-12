class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String? senderImage;
  final String text;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessageModel({
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // sender can be a string id or an object { _id, name, image }
    String parsedSenderId = '';
    String? parsedSenderName;
    String? parsedSenderImage;
    final dynamic senderValue = json['sender'];
    if (senderValue is Map) {
      parsedSenderId = (senderValue['_id'] ?? '').toString();
      parsedSenderName = senderValue['name']?.toString();
      parsedSenderImage = senderValue['image']?.toString();
    } else if (senderValue != null) {
      parsedSenderId = senderValue.toString();
    }

    return ChatMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: parsedSenderId,
      senderName: parsedSenderName,
      senderImage: parsedSenderImage,
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
      // For outbound, include only senderId to keep payload light
      'sender': senderId,
      'text': text,
      if (image != null) 'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
