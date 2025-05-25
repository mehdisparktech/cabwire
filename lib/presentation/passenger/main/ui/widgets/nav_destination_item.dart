import 'package:cabwire/core/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:cabwire/core/external_libs/svg_image.dart';

class NavDestinationItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String iconPath;
  final String label;
  final ValueChanged<int> onTap;

  const NavDestinationItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    final Color activeColor = AppColor.primary;
    final Color inactiveColor = Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgImage(
              iconPath,
              color: isSelected ? activeColor : inactiveColor,
              height: 24,
              width: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: isSelected ? 30 : 0,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
