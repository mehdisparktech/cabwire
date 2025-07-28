import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/config/app_assets.dart';

// एक मेसेज मॉडेल
class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSender; // पाठवणारा की स्वीकारणारा
  final bool showAvatar; // फक्त स्वीकारणाऱ्यासाठी

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
    // सॅम्पल डेटा
    return ChatUiState(
      isLoading: false,
      userMessage: '',
      chatPartnerName: 'Mandy',
      chatPartnerStatus: 'Online',
      chatPartnerAvatarUrl: AppAssets.icProfileImage,
      messages: [
        ChatMessage(
          id: '1',
          text: "Hi, Mandy",
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSender: false,
          showAvatar: true,
        ),
        ChatMessage(
          id: '2',
          text: "I've tried the app",
          timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          isSender: false,
        ),
        ChatMessage(
          id: '3',
          text: "Really?",
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          isSender: true,
        ),
        ChatMessage(
          id: '4',
          text: "Yeah, it's really good!",
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          isSender: false,
        ),
      ],
      isTyping: true,
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
