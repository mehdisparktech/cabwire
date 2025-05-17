import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_text.dart';
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacityInt(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: context.theme.colorScheme.primary,
            ),
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
