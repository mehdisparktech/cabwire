import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType buttonType;
  final double width;
  final IconData? prefixIcon;

  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = ButtonType.primary,
    this.width = double.infinity,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = buttonType == ButtonType.primary;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? context.color.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPrimary ? Colors.transparent : context.color.primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon,
                color:
                    isPrimary
                        ? context.color.btnText
                        : context.color.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color:
                    isPrimary
                        ? context.color.btnText
                        : context.color.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
