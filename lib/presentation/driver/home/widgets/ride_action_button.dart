import 'package:flutter/material.dart';

class RideActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double? borderRadius;

  const RideActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return isPrimary
        ? Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6600), Color(0xFFFF8800)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
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
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: Colors.deepOrange, width: 1.5),
            foregroundColor: Colors.black,
          ),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
  }
}
