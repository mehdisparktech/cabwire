import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/static/app_colors.dart';

class AppLogoDisplay extends StatelessWidget {
  final String logoAssetPath;
  final String logoAssetPath2;
  final Color? color;

  const AppLogoDisplay({
    super.key,
    required this.logoAssetPath,
    required this.logoAssetPath2,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacityInt(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CommonImage(
            imageSrc: logoAssetPath,
            width: px110,
            height: px110,
          ),
        ),
        gapH16,
        CommonImage(imageSrc: logoAssetPath2, width: px200, height: px34),
      ],
    );
  }
}
