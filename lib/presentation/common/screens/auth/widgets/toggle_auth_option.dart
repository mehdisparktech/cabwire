import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import '../../../../../core/static/app_colors.dart';

class ToggleAuthOption extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onActionPressed;

  const ToggleAuthOption({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            leadingText,
            style: const TextStyle(color: AppColors.textBlack87),
          ),
          TextButton(
            onPressed: onActionPressed,
            // Style comes from TextButtonTheme in AppTheme
            child: Text(
              actionText,
              style: TextStyle(
                color: context.color.primaryBtn,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
