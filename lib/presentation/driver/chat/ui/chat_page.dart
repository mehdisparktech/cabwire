import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/chat/ui/audio_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leadingWidth: 40,
      titleSpacing: 5,
      leading: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.black,
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(AppAssets.icProfileImage),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () => Get.to(() => const AudioCallScreen()),
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacityInt(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(Icons.phone, color: context.theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildChatMessages()),
        _buildMessageInput(context),
      ],
    );
  }

  Widget _buildChatMessages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                '09:41 AM',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          _buildReceiverMessage("Hi, Mandy", true),
          const SizedBox(height: 8),
          _buildReceiverMessage("I've tried the app"),
          const SizedBox(height: 8),
          _buildSenderMessage("Really?"),
          const SizedBox(height: 8),
          _buildReceiverMessage("Yeah, it's really good!"),
          const SizedBox(height: 8),
          _buildTypingIndicator(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReceiverMessage(String message, [bool showAvatar = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
        if (showAvatar) ...[
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage(AppAssets.icProfileImage),
          ),
        ] else
          const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildSenderMessage(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(message, style: const TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const Text('Typing...', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      height: px100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacityInt(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Type your message',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                filled: false,
                suffixIcon: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
