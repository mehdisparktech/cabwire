import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/config/app_assets.dart';

class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSender;
  final bool showAvatar;

  ChatMessage({
    required this.id,
    required this.text,
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

  const ChatUiState({
    required super.isLoading,
    required super.userMessage,
    required this.chatPartnerName,
    required this.chatPartnerStatus,
    required this.chatPartnerAvatarUrl,
    required this.messages,
    required this.isTyping,
    required this.currentMessageText,
  });

  factory ChatUiState.initial() {
    return ChatUiState(
      isLoading: false,
      userMessage: '',
      chatPartnerName: 'Mandy',
      chatPartnerStatus: 'Online',
      chatPartnerAvatarUrl: AppAssets.icProfileImage,
      messages: [],
      isTyping: false,
      currentMessageText: '',
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
    );
  }
}
