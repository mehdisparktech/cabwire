import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/chat/ui/audio_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneButton extends StatelessWidget {
  final double? padding;
  final double? margin;
  const PhoneButton({super.key, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const AudioCallScreen()),
      child: Container(
        padding: EdgeInsets.all(padding ?? 10),
        margin: EdgeInsets.only(right: margin ?? 20),
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
    );
  }
}
