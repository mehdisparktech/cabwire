import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final IconData fallbackIcon;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final BoxShape shape;

  const ImagePreviewWidget({
    super.key,
    this.imagePath,
    this.width = 120.0,
    this.height = 120.0,
    this.fallbackIcon = Icons.image,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.white,
    this.iconSize = 60.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(8) : null,
      ),
      child:
          imagePath != null
              ? shape == BoxShape.circle
                  ? ClipOval(
                    child: Image.file(
                      File(imagePath!),
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imagePath!),
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                  )
              : Icon(fallbackIcon, size: iconSize, color: iconColor),
    );
  }
}
