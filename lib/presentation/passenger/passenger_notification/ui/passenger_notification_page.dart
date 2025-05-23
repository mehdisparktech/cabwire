import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:cabwire/presentation/passenger/passenger_notification/presenter/passenger_notification_presenter.dart';
import 'package:cabwire/presentation/passenger/passenger_notification/widgets/passenger_notification_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerNotificationScreen extends StatelessWidget {
  PassengerNotificationScreen({super.key});
  final PassengerNotificationPresenter _presenter =
      locate<PassengerNotificationPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder<PassengerNotificationPresenter>(
      presenter: _presenter,
      builder: () {
        final notifications = _presenter.currentUiState.notifications;
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
              itemCount: notifications?.length ?? 0,
              itemBuilder: (context, index) {
                return PassengerNotificationItem(
                  title: notifications?[index].title ?? '',
                  description: notifications?[index].description ?? '',
                  time: notifications?[index].time ?? '',
                );
              },
            ),
          ),
        );
      },
    );
  }
}
