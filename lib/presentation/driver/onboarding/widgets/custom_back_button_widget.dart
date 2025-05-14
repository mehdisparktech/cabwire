import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButtonWidget extends StatelessWidget {
  const CustomBackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.color.backgroundColor,
          border: Border.all(
            color: context.color.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: context.color.primaryColor,
          size: 16,
        ),
      ),
    );
  }
}
