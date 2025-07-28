import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double? borderRadius;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isPrimary
        ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //colors: [Color(0xFFFF6600), Color(0xFFFF8800)],
              colors: [
                context.color.primaryButtonGradient,
                context.color.secondaryButtonGradient,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? px8),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(px8),
              ),
            ),
            child:
                isLoading
                    ? SizedBox(
                      height: 3.h,
                      width: 6.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        )
        : OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: px14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(px8),
            ),
            side: BorderSide(
              color: context.color.primaryButtonGradient,
              width: 1.5,
            ),
            foregroundColor: Colors.black,
          ),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
  }
}
