import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? color;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: twentyFourPx,
        vertical: fiftyPx,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.displayMedium?.copyWith(
              fontSize: thirtyFourPx,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          gapH6,
          Text(
            subtitle,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: fourteenPx,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
