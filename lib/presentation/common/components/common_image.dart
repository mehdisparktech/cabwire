import 'package:cabwire/core/config/app_assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { png, svg, network }

class CommonImage extends StatelessWidget {
  final String imageSrc;
  final String defaultImage;
  final Color? imageColor;
  final double height;
  final double width;
  final double borderRadius;
  final double? size;
  final ImageType imageType;
  final BoxFit fill;

  const CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height = 24,
    this.borderRadius = 0,
    this.width = 24,
    this.size,
    this.imageType = ImageType.svg,
    this.fill = BoxFit.fill,
    this.defaultImage = AppAssets.icNoImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageType == ImageType.svg) {
      imageWidget = SvgPicture.asset(
        imageSrc,
        // ignore: deprecated_member_use
        color: imageColor,
        height: size ?? height,
        width: size ?? width,
        fit: fill,
      );
    } else if (imageType == ImageType.png) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imageSrc,
          color: imageColor,
          height: size ?? height,
          width: size ?? width,
          fit: fill,
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode) {
              print("imageError : $error");
            }
            return Image.asset(defaultImage);
          },
        ),
      );
    } else {
      imageWidget = CachedNetworkImage(
        height: size ?? height,
        width: size ?? width,
        imageUrl: imageSrc,
        imageBuilder:
            (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              ),
            ),
        progressIndicatorBuilder:
            (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) {
          if (kDebugMode) {
            print(error);
          }
          return Image.asset(defaultImage);
        },
      );
    }

    return SizedBox(
      height: size ?? height,
      width: size ?? width,
      child: imageWidget,
    );
  }
}
