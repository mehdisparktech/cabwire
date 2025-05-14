import 'package:flutter/material.dart';
import '../../../../core/static/app_colors.dart';

class ToggleAuthOption extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onActionPressed;

  const ToggleAuthOption({
    Key? key,
    required this.leadingText,
    required this.actionText,
    required this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText, style: const TextStyle(color: AppColors.textBlack87)),
        TextButton(
          onPressed: onActionPressed,
          // Style comes from TextButtonTheme in AppTheme
          child: Text(actionText),
        ),
      ],
    );
  }
}
