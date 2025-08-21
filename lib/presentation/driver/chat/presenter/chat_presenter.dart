import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:cabwire/domain/usecases/chat/get_messages_by_chat_id_usecase.dart';
import 'package:cabwire/domain/usecases/chat/send_message_usecase.dart';
import 'package:cabwire/presentation/driver/chat/presenter/chat_ui_state.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPresenter extends BasePresenter<ChatUiState> {
  final GetMessagesByChatIdUseCase _getMessagesByChatIdUseCase;
  final SocketService _socketService;
  final SendMessageUseCase _sendMessageUseCase;
  final Obs<ChatUiState> uiState = Obs<ChatUiState>(ChatUiState.initial());
  ChatUiState get currentUiState => uiState.value;

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  String? _currentChatId;
  Timer? _reconnectTimer;

  ChatPresenter(
    this._getMessagesByChatIdUseCase,
    this._sendMessageUseCase,
    this._socketService,
  );

  void initial(String chatId) {
    // Only load messages if not already loaded for this chat
    if (_currentChatId != chatId) {
      _currentChatId = chatId;
      _loadInitialMessages(chatId);
      _ensureSocketConnection();
      // / Add a small delay to ensure socket is connected before setting up listeners
      Future.delayed(const Duration(milliseconds: 500), () {
        _setupSocketListeners();
      });

      _startReconnectMonitor();
    }
  }

  void _ensureSocketConnection() {
    appLog("Checking socket connection...");
    if (!_socketService.isConnected) {
      appLog("Socket not connected. Connecting...");
      _socketService.connectToSocket();
    } else {
      appLog("Socket is already connected.");
    }
  }

  //start reconnect monitor
  void _startReconnectMonitor() {
    appLog("Starting reconnect monitor...");
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_socketService.isConnected) {
        appLog("Socket disconnected. Attempting to reconnect...");
        _socketService.connectToSocket();
        // Re-setup listeners after reconnection
        _setupSocketListeners();
      }
    });
  }

  //setup socket listeners
  void _setupSocketListeners() {
    appLog("Setting up socket listeners...");
    if (_currentChatId == null) return;

    final eventName = 'getMessage::$_currentChatId';
    appLog("Setting up socket listeners for event: $eventName");

    // First, remove any existing listeners to avoid duplicates
    _socketService.off(eventName);

    // Setup fresh listener with extra debugging
    _socketService.on(eventName, (dynamic data) {
      appLog("SOCKET_EVENT_RECEIVED: Event $eventName triggered");
      appLog("SOCKET_DATA_DEBUG: Raw data received: $data");

      // Handle different data types
      try {
        if (data is Map) {
          final Map<String, dynamic> messageData = Map<String, dynamic>.from(
            data,
          );
          appLog("SOCKET_DEBUG: Message data: $messageData");

          // Examine text field specifically
          final textValue = messageData['text'];
          appLog("SOCKET_DEBUG: Text field value: '$textValue'");

          // Process the message
          if (messageData.containsKey('sender') &&
              messageData['sender'] != LocalStorage.userId) {
            appLog(
              "Message is not from the current user: ${messageData['sender'] != LocalStorage.userId}",
            );
            _handleMessageReceived(messageData);
          } else {
            appLog("SOCKET_DEBUG: Message data does not contain text field");
          }
        } else {
          appLog("SOCKET_DEBUG: Received non-Map data: $data");
        }
      } catch (e, stackTrace) {
        appLog("SOCKET_DEBUG: Error processing socket event: $e");
        appLog("SOCKET_DEBUG: Stack trace: $stackTrace");
      }
    });

    appLog("Socket listeners setup complete for event: $eventName");
  }

  void _handleMessageReceived(Map<String, dynamic> data) {
    appLog("MESSAGE_PROCESSING: Processing message data: $data");

    try {
      // Extract text with safety checks
      final textValue = data['text'];
      final String messageText = textValue?.toString() ?? '';

      appLog("MESSAGE_PROCESSING: Extracted text: '$messageText'");

      if (messageText.isNotEmpty) {
        appLog(
          "MESSAGE_PROCESSING: Creating message with text: '$messageText'",
        );

        // Create new chat message
        final newMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: messageText,
          timestamp: DateTime.now(),
          isSender: false,
          senderImage: currentUiState.chatPartnerName,
        );

        // Update UI state
        final updatedMessages = [...currentUiState.messages, newMessage];
        uiState.value = currentUiState.copyWith(messages: updatedMessages);

        appLog("MESSAGE_PROCESSING: Message added successfully to UI state");
        _scrollToBottom();
      } else {
        appLog("MESSAGE_PROCESSING: Empty message text, not adding to UI");
      }
    } catch (e, stackTrace) {
      appLog("MESSAGE_PROCESSING: Error handling message: $e");
      appLog("MESSAGE_PROCESSING: Stack trace: $stackTrace");
    }
  }

  Future<void> _loadInitialMessages(String chatId) async {
    final userId = LocalStorage.userId;
    final result = await _getMessagesByChatIdUseCase.execute(
      GetMessagesByChatIdParams(chatId: chatId),
    );
    result.fold((failure) => showMessage(message: failure.toString()), (
      messages,
    ) {
      final sortedMessages =
          messages
              .map(
                (e) => ChatMessage(
                  id: e.id,
                  text: e.text,
                  timestamp: e.createdAt,
                  isSender: e.senderId == userId,
                  senderId: e.senderId,
                  senderName: e.senderId == userId ? null : e.senderName,
                  senderImage: e.senderId == userId ? null : e.senderImage,
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.timestamp.compareTo(b.timestamp),
            ); // Sort by timestamp ascending

      // pick first partner message (not from current user)
      String partnerName = currentUiState.chatPartnerName;
      String partnerImage = currentUiState.chatPartnerAvatarUrl;
      for (final m in sortedMessages) {
        if (!m.isSender) {
          if ((m.senderName ?? '').isNotEmpty) partnerName = m.senderName!;
          if ((m.senderImage ?? '').isNotEmpty) partnerImage = m.senderImage!;
          break;
        }
      }

      uiState.value = currentUiState.copyWith(
        messages: sortedMessages,
        chatPartnerName: partnerName,
        chatPartnerAvatarUrl: partnerImage,
        isLoading: false,
      );
    });
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  void onMessageTextChanged(String text) {
    uiState.value = currentUiState.copyWith(currentMessageText: text);
    // _chatService.sendTypingEvent(isTyping: text.isNotEmpty);
  }

  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isSender: true,
    );

    final updatedMessages = List<ChatMessage>.from(currentUiState.messages)
      ..add(newMessage);
    uiState.value = currentUiState.copyWith(
      messages: updatedMessages,
      currentMessageText: '',
    );
    messageController.clear();

    final result = await _sendMessageUseCase.execute(
      SendMessageParams(chatId: chatId, text: text),
    );
    result.fold(
      (failure) => showMessage(message: failure.toString()),
      (message) => debugPrint(message.text),
    );
    _scrollToBottom();
  }

  // ignore: unused_element
  void _addReceivedMessage(String text, String senderId) {
    final receivedMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isSender: false,
      // showAvatar: logic to show avatar or not
    );
    final updatedMessages = List<ChatMessage>.from(currentUiState.messages)
      ..add(receivedMessage);
    uiState.value = currentUiState.copyWith(messages: updatedMessages);
    _scrollToBottom();
  }

  // ignore: unused_element
  void _updateTypingStatus(bool isTyping) {
    uiState.value = currentUiState.copyWith(isTyping: isTyping);
    if (isTyping) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void goBack() {
    Get.back();
  }

  void startAudioCall() {
    Get.to(() => const AudioCallScreen());
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
