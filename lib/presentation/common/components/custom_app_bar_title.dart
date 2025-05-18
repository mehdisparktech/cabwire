import 'package:cabwire/core/config/app_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.bodyMedium!.copyWith(
        fontSize: px18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
