import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/driver/chat/presenter/chat_presenter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final ChatPresenter presenter = locate<ChatPresenter>();

  ChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    presenter.initial(chatId);
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Scaffold(
          appBar: _buildAppBar(context, presenter),
          body: _buildBody(context, presenter),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, ChatPresenter presenter) {
    final uiState = presenter.currentUiState;
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      elevation: 1,
      leadingWidth: 45,
      titleSpacing: 5,
      leading: IconButton(
        onPressed: presenter.goBack,
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                (uiState.chatPartnerAvatarUrl.isNotEmpty)
                    ? CachedNetworkImageProvider(
                      ApiEndPoint.imageUrl + uiState.chatPartnerAvatarUrl,
                      errorListener:
                          (error) => AssetImage(AppAssets.icProfileImage),
                    )
                    : AssetImage(AppAssets.icProfileImage) as ImageProvider,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                uiState.chatPartnerName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                uiState.chatPartnerStatus,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      actions: [
        CircularIconButton(icon: Icons.phone, onTap: presenter.startAudioCall),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ChatPresenter presenter) {
    return Column(
      children: [
        Expanded(child: _buildChatMessages(presenter)),
        _buildMessageInput(context, presenter),
      ],
    );
  }

  Widget _buildChatMessages(ChatPresenter presenter) {
    final uiState = presenter.currentUiState;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        controller: presenter.scrollController,
        itemCount:
            uiState.messages.length +
            (uiState.isTyping ? 1 : 0) +
            1, // +1 date header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  DateFormat('hh:mm a').format(
                    uiState.messages.isNotEmpty
                        ? uiState.messages.first.timestamp
                        : DateTime.now(),
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            );
          }

          final messageIndex = index - 1;

          if (uiState.isTyping && messageIndex == uiState.messages.length) {
            return _buildTypingIndicator(
              presenter.currentUiState.chatPartnerAvatarUrl,
            );
          }
          if (messageIndex >= uiState.messages.length) {
            return const SizedBox.shrink();
          }

          final message = uiState.messages[messageIndex];
          if (!message.isSender) {
            return _buildSenderMessage(message.text, message.senderImage);
          } else {
            return _buildReceiverMessage(
              message.text,
              message.showAvatar,
              message.senderImage,
            );
          }
        },
      ),
    );
  }

  Widget _buildReceiverMessage(
    String message,
    bool showAvatar,
    String? avatarUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
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
            CircleAvatar(
              radius: 12,
              backgroundImage:
                  (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? CachedNetworkImageProvider(
                        ApiEndPoint.imageUrl + avatarUrl,
                        errorListener:
                            (error) => AssetImage(AppAssets.icProfileImage),
                      )
                      : AssetImage(AppAssets.icProfileImage) as ImageProvider,
            ),
          ] else
            const SizedBox(width: 24 + 8),
        ],
      ),
    );
  }

  Widget _buildSenderMessage(String message, String? avatarUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage:
                (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? CachedNetworkImageProvider(
                      ApiEndPoint.imageUrl + avatarUrl,
                      errorListener:
                          (error) => AssetImage(AppAssets.icProfileImage),
                    )
                    : AssetImage(AppAssets.icProfileImage) as ImageProvider,
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
      ),
    );
  }

  Widget _buildTypingIndicator(String avatarAsset) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
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
            child: const Text(
              'Typing...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatPresenter presenter) {
    return Container(
      height: 100,
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
              controller: presenter.messageController,
              onChanged: presenter.onMessageTextChanged,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                hintText: 'Type your message',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                filled: false,
                suffixIcon: GestureDetector(
                  onTap: () => presenter.sendMessage(chatId),
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
