import 'package:flutter/material.dart';
import '../../../../core/static/app_colors.dart';

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 8), // Original padding
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }
}
