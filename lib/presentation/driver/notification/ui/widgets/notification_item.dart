import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/circular_icon_button.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.title,
    required this.description,
    required this.time,
  });

  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.colorScheme.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularIconButton(
            imageSrc: AppAssets.icNotificationBing,
            onTap: () {},
          ),
          gapW16,

          SizedBox(
            width: 255,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: title,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                ),

                CommonText(
                  text: description,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  color: Colors.black,
                  textAlign: TextAlign.start,
                  bottom: 10,
                  top: 4,
                ),
              ],
            ),
          ),
          CommonText(
            text: time,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,

            color: Colors.black,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
