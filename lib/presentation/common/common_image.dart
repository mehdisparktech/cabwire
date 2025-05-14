import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonImage extends StatelessWidget {
  const CommonImage(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return SvgPicture.asset(
        assetPath,
        fit: fit,
        height: height,
        width: width,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      );
    } else {
      return Image.asset(
        assetPath,
        fit: fit,
        height: height,
        width: width,
        color: color,
      );
    }
  }
}
