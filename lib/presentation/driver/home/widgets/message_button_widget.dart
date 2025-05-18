import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme and Get.snackbar

class MessageButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const MessageButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: context.theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(22),
        ),
        child: InkWell(
          onTap:
              onTap ??
              () {
                // Default action if no onTap is provided
                Get.snackbar("Message", "Send a free message tapped!");
              },
          borderRadius: BorderRadius.circular(22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                color: context.theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Send a free message',
                style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
