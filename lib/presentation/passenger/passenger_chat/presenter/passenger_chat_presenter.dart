import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/usecases/chat/get_messages_by_chat_id_usecase.dart';
import 'package:cabwire/domain/usecases/chat/send_message_usecase.dart';
import 'package:cabwire/presentation/passenger/passenger_chat/presenter/passenger_chat_ui_state.dart';
import 'package:cabwire/presentation/passenger/passenger_chat/ui/screens/passenger_audio_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerChatPresenter extends BasePresenter<PassengerChatUiState> {
  final GetMessagesByChatIdUseCase _getMessagesByChatIdUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final Obs<PassengerChatUiState> uiState = Obs<PassengerChatUiState>(
    PassengerChatUiState.initial(),
  );
  PassengerChatUiState get currentUiState => uiState.value;

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  String? _currentChatId;

  PassengerChatPresenter(
    this._getMessagesByChatIdUseCase,
    this._sendMessageUseCase,
  );

  void initial(String chatId) {
    // Only load messages if not already loaded for this chat
    if (_currentChatId != chatId) {
      _currentChatId = chatId;
      _loadInitialMessages(chatId);
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
                (e) => PassengerChatMessage(
                  id: e.id,
                  text: e.text,
                  timestamp: e.createdAt,
                  isSender: e.sender == userId,
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.timestamp.compareTo(b.timestamp),
            ); // Sort by timestamp ascending

      uiState.value = currentUiState.copyWith(messages: sortedMessages);
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

    final newMessage = PassengerChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isSender: true,
    );

    final updatedMessages = List<PassengerChatMessage>.from(
      currentUiState.messages,
    )..add(newMessage);
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
    final receivedMessage = PassengerChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isSender: false,
      // showAvatar: logic to show avatar or not
    );
    final updatedMessages = List<PassengerChatMessage>.from(
      currentUiState.messages,
    )..add(receivedMessage);
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
    Get.to(() => const PassengerAudioCallPage());
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
