import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';

class DotIndicatorWidget extends StatelessWidget {
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;

  const DotIndicatorWidget({
    super.key,
    required this.isActive,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color:
            isActive
                ? activeColor ?? context.color.primaryColor
                : inactiveColor ??
                    context.color.secondaryTextColor.withOpacityInt(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
