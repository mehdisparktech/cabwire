import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? radius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: context.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [
              context.color.primaryButtonGradient,
              context.color.secondaryButtonGradient,
            ],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: context.color.primaryColor),
            borderRadius: BorderRadius.circular(radius ?? 200),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white /* Text-Primary */,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
