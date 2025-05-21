import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({
    super.key,
    this.icon,
    required this.title,
    this.image = "",
    this.disableDivider = false,
    this.onTap,
    this.color = Colors.black,
    this.vertical = 4,
    this.horizontal = 00,
    this.disableIcon = false,
  });

  final IconData? icon;
  final String title;
  final String image;
  final bool disableDivider;
  final bool disableIcon;
  final VoidCallback? onTap;
  final Color color;
  final double vertical;
  final double horizontal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: Column(
          children: [
            Row(
              children: [
                icon != null
                    ? Icon(icon, color: color)
                    : CommonImage(imageSrc: image),
                CommonText(
                  text: title,
                  color: color,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  left: 16,
                ),
                const Spacer(),
                disableIcon
                    ? const SizedBox()
                    : Icon(
                      color: Colors.black,
                      Icons.arrow_forward_ios_outlined,
                      size: 20,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
