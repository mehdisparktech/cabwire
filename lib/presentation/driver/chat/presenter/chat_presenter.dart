import 'dart:async';
import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/presentation/driver/chat/presenter/chat_ui_state.dart';
import 'package:cabwire/presentation/driver/chat/ui/screens/audio_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPresenter extends BasePresenter<ChatUiState> {
  final Obs<ChatUiState> uiState = Obs<ChatUiState>(ChatUiState.initial());
  ChatUiState get currentUiState => uiState.value;

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  ChatPresenter() {
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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

  void sendMessage() {
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

    // _chatService.sendMessage(text);
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
