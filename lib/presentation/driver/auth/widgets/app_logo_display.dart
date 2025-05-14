import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/static/app_colors.dart';

class AppLogoDisplay extends StatelessWidget {
  final String logoAssetPath;
  final String appName;

  const AppLogoDisplay({
    super.key,
    required this.logoAssetPath,
    required this.appName,
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
          child:
              logoAssetPath.endsWith('.svg')
                  ? SvgPicture.asset(logoAssetPath, width: 48, height: 48)
                  : Image.asset(
                    logoAssetPath,
                    width: 48,
                    height: 48,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.local_taxi,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
        ),
        const SizedBox(height: 16),
        Text(
          appName,
          style: const TextStyle(
            color: AppColors.textBlack87,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
