import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/helpers/datetime_helper.dart';
import 'package:cabwire/presentation/driver/notification/presenter/notification_presenter.dart';
import 'package:cabwire/presentation/driver/notification/ui/widgets/notification_item.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationPresenter _presenter = locate<NotificationPresenter>();

  @override
  Widget build(BuildContext context) {
    // Fetch notifications when the page is built
    _presenter.getNotifications();

    return PresentableWidgetBuilder<NotificationPresenter>(
      presenter: _presenter,
      builder: () {
        final notifications = _presenter.currentUiState.notifications;
        final isLoading = _presenter.currentUiState.isLoading;

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
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifications == null || notifications.isEmpty
                  ? const Center(child: Text("No notifications found"))
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final notificationItems = notification.data?.result;

                        if (notificationItems == null ||
                            notificationItems.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        // Sort notification items by createdAt in descending order (newest first)
                        final sortedItems = [...notificationItems]
                          ..sort((a, b) {
                            final aTime = a.createdAt ?? DateTime(1900);
                            final bTime = b.createdAt ?? DateTime(1900);
                            return bTime.compareTo(aTime); // Descending order
                          });

                        return Column(
                          children:
                              sortedItems
                                  .map(
                                    (item) => NotificationItem(
                                      title:
                                          item.userId?.name ??
                                          item.receiver?.name ??
                                          'Unknown',
                                      description:
                                          item.text ?? 'No description',
                                      time: DateTimeHelper.timeAgo(
                                        item.createdAt,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        );
                      },
                    ),
                  ),
        );
      },
    );
  }
}
