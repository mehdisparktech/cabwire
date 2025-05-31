import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For context.theme and Get.snackbar

class MessageButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const MessageButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Container(
        height: 44.px,
        decoration: BoxDecoration(
          border: Border.all(color: context.theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(22.px),
        ),
        child: InkWell(
          onTap:
              onTap ??
              () {
                // Default action if no onTap is provided
                Get.snackbar("Message", "Send a message tapped!");
              },
          borderRadius: BorderRadius.circular(22.px),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                color: context.theme.colorScheme.primary,
                size: 16.px,
              ),
              gapW8,
              CustomText(
                'Send a message',
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.primary,
                fontSize: 16.px,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
