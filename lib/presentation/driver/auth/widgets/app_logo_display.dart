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
          child: CommonImage(logoAssetPath, width: 80, height: 120),
        ),
        const SizedBox(height: 16),
        CommonImage(logoAssetPath2, width: 200, height: 34),
      ],
    );
  }
}
