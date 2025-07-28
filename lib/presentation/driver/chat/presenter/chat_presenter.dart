import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/usecases/chat/get_messages_by_chat_id_usecase.dart';
import 'package:cabwire/domain/usecases/chat/send_message_usecase.dart';
import 'package:cabwire/presentation/driver/chat/presenter/chat_ui_state.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/services/storage/storage_services.dart';

class ChatPresenter extends BasePresenter<ChatUiState> {
  final GetMessagesByChatIdUseCase _getMessagesByChatIdUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final Obs<ChatUiState> uiState = Obs<ChatUiState>(ChatUiState.initial());
  ChatUiState get currentUiState => uiState.value;

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  ChatPresenter(this._getMessagesByChatIdUseCase, this._sendMessageUseCase) {
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    final userId = LocalStorage.userId;
    final result = await _getMessagesByChatIdUseCase.execute(
      GetMessagesByChatIdParams(chatId: '123'),
    );
    result.fold(
      (failure) => showMessage(message: failure.toString()),
      (messages) =>
          uiState.value = currentUiState.copyWith(
            messages:
                messages
                    .map(
                      (e) => ChatMessage(
                        id: e.id,
                        text: e.text,
                        timestamp: e.createdAt,
                        isSender: e.sender == userId,
                      ),
                    )
                    .toList(),
          ),
    );
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

  Future<void> sendMessage() async {
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
      SendMessageParams(chatId: '123', text: text),
    );
    result.fold(
      (failure) => showMessage(message: failure.toString()),
      (message) => _addReceivedMessage(message.text, message.sender),
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
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
