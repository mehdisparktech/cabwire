import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/core/config/app_assets.dart';

// एक मेसेज मॉडेल
class PassengerChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSender; // पाठवणारा की स्वीकारणारा
  final bool showAvatar; // फक्त स्वीकारणाऱ्यासाठी

  PassengerChatMessage({
    required this.id,
    required this.text,
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
    // सॅम्पल डेटा
    return PassengerChatUiState(
      isLoading: false,
      userMessage: '',
      chatPartnerName: 'Mandy',
      chatPartnerStatus: 'Online',
      chatPartnerAvatarUrl: AppAssets.icProfileImage,
      messages: [
        PassengerChatMessage(
          id: '1',
          text: "Hi, Mandy",
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSender: false,
          showAvatar: true,
        ),
        PassengerChatMessage(
          id: '2',
          text: "I've tried the app",
          timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          isSender: false,
        ),
        PassengerChatMessage(
          id: '3',
          text: "Really?",
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          isSender: true,
        ),
        PassengerChatMessage(
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
