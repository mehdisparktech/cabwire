import 'package:cabwire/core/config/app_assets.dart';
import 'package:flutter/material.dart';

class DriverProfileWidget extends StatelessWidget {
  final String name;
  final String? address;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const DriverProfileWidget({
    super.key,
    required this.name,
    this.address,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: backgroundColor ?? Colors.blue.shade200,
          backgroundImage: AssetImage(AppAssets.icProfileImage),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    textStyle ??
                    TextStyle(fontSize: 14, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              address != null
                  ? Text(
                    address!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
