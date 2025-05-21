import 'package:cabwire/presentation/driver/notification/widgets/notification_item.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: 'OTP Verify!',
        description: 'Your OTP is required to close the trip. Enter it now.',
        time: '1 h',
      ),
      NotificationItem(
        title: 'Payment Successful',
        description: 'Payment successfully processed. Thank you!',
        time: '2 h',
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: CommonText(
          color: Colors.black,
          text: 'Notifications',
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationItem(
              title: notifications[index].title,
              description: notifications[index].description,
              time: notifications[index].time,
            );
          },
        ),
      ),
    );
  }
}
