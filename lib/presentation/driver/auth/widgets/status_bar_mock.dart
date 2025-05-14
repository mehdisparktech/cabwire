import 'package:flutter/material.dart';
import '../../../../core/static/app_colors.dart';

class StatusBarMock extends StatelessWidget {
  const StatusBarMock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This padding ensures the status bar contents are aligned with other page content
    // if the parent container (like AuthHeader) has horizontal padding.
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Adjusted top padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "9:41",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack87,
            ),
          ),
          Row(
            children: const [
              Icon(
                Icons.signal_cellular_4_bar,
                size: 16,
                color: AppColors.textBlack87,
              ),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16, color: AppColors.textBlack87),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 16, color: AppColors.textBlack87),
            ],
          ),
        ],
      ),
    );
  }
}
