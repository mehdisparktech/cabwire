import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/config/app_assets.dart';

class ChatMessage {
  final String id;
  final String text;
  final String? senderId;
  final String? senderName;
  final String? senderImage;
  final DateTime timestamp;
  final bool isSender;
  final bool showAvatar;

  ChatMessage({
    required this.id,
    required this.text,
    this.senderId,
    this.senderName,
    this.senderImage,
    required this.timestamp,
    required this.isSender,
    this.showAvatar = false,
  });
}

class ChatUiState extends BaseUiState {
  final String chatPartnerName;
  final String chatPartnerStatus;
  final String chatPartnerAvatarUrl;
  final List<ChatMessage> messages;
  final bool isTyping;
  final String currentMessageText;
  final String partnerImage;

  const ChatUiState({
    required super.isLoading,
    required super.userMessage,
    required this.chatPartnerName,
    required this.chatPartnerStatus,
    required this.chatPartnerAvatarUrl,
    required this.messages,
    required this.isTyping,
    required this.currentMessageText,
    required this.partnerImage,
  });

  factory ChatUiState.initial() {
    return ChatUiState(
      isLoading: true,
      userMessage: '',
      chatPartnerName: 'Loading...',
      chatPartnerStatus: 'Connecting...',
      chatPartnerAvatarUrl: AppAssets.icProfileImage,
      messages: [],
      isTyping: false,
      currentMessageText: '',
      partnerImage: AppAssets.icProfileImage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    chatPartnerName,
    chatPartnerStatus,
    chatPartnerAvatarUrl,
    messages,
    isTyping,
    currentMessageText,
    partnerImage,
  ];

  ChatUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? chatPartnerName,
    String? chatPartnerStatus,
    String? chatPartnerAvatarUrl,
    List<ChatMessage>? messages,
    bool? isTyping,
    String? currentMessageText,
    String? partnerImage,
  }) {
    return ChatUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      chatPartnerName: chatPartnerName ?? this.chatPartnerName,
      chatPartnerStatus: chatPartnerStatus ?? this.chatPartnerStatus,
      chatPartnerAvatarUrl: chatPartnerAvatarUrl ?? this.chatPartnerAvatarUrl,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      currentMessageText: currentMessageText ?? this.currentMessageText,
      partnerImage: partnerImage ?? this.partnerImage,
    );
  }
}
