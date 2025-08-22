import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/config/app_assets.dart';

class PassengerChatMessage {
  final String id;
  final String text;
  final String? senderId;
  final String? senderName;
  final String? senderImage;
  final DateTime timestamp;
  final bool isSender;
  final bool showAvatar;

  PassengerChatMessage({
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

class PassengerChatUiState extends BaseUiState {
  final String chatPartnerName;
  final String chatPartnerStatus;
  final String chatPartnerAvatarUrl;
  final List<PassengerChatMessage> messages;
  final bool isTyping;
  final String currentMessageText;

  const PassengerChatUiState({
    required super.isLoading,
    required super.userMessage,
    required this.chatPartnerName,
    required this.chatPartnerStatus,
    required this.chatPartnerAvatarUrl,
    required this.messages,
    required this.isTyping,
    required this.currentMessageText,
  });

  factory PassengerChatUiState.initial() {
    return PassengerChatUiState(
      isLoading: true,
      userMessage: '',
      chatPartnerName: 'Loading...',
      chatPartnerStatus: 'Connecting...',
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

  PassengerChatUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? chatPartnerName,
    String? chatPartnerStatus,
    String? chatPartnerAvatarUrl,
    List<PassengerChatMessage>? messages,
    bool? isTyping,
    String? currentMessageText,
  }) {
    return PassengerChatUiState(
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
