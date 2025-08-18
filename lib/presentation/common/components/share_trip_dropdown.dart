import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareTripDropdown extends StatelessWidget {
  final String rideId;
  final VoidCallback? onWhatsAppShare;
  final VoidCallback? onMessengerShare;
  final VoidCallback? onEmailShare;
  final VoidCallback? onGeneralShare;

  const ShareTripDropdown({
    super.key,
    required this.rideId,
    this.onWhatsAppShare,
    this.onMessengerShare,
    this.onEmailShare,
    this.onGeneralShare,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'whatsapp':
            onWhatsAppShare?.call();
            break;
          case 'messenger':
            onMessengerShare?.call();
            break;
          case 'email':
            onEmailShare?.call();
            break;
          case 'general':
            onGeneralShare?.call();
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'whatsapp',
              child: Row(
                children: [
                  Icon(Icons.chat, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'WhatsApp',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'messenger',
              child: Row(
                children: [
                  Icon(Icons.messenger_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Messenger',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'email',
              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'general',
              child: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: context.theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'More Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
      child: Text(
        'Share Trip',
        style: TextStyle(
          fontSize: 12,
          color: context.theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
