import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? padding;
  final double? margin;
  final VoidCallback onTap;
  final String? imageSrc;
  final ImageType? imageType;

  const CircularIconButton({
    super.key,
    this.icon,
    this.imageSrc,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.imageType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding ?? 10),
        margin: EdgeInsets.symmetric(horizontal: margin ?? 8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacityInt(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child:
            icon == null
                ? CommonImage(
                  imageType: imageType ?? ImageType.svg,
                  imageSrc: imageSrc ?? '',
                )
                : Icon(icon, color: iconColor ?? context.color.primaryColor),
      ),
    );
  }
}
