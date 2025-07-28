import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
// If you decide to use GetX for theming directly in this widget, uncomment:
// import 'package:get/get.dart';

class TopNavigationBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final String distance;
  final String address;
  final VoidCallback? onBackPressed;

  const TopNavigationBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.address,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(color: const Color(0xFFFFD5A9)),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBackPressed,
              child: const Icon(Icons.arrow_back, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              distance,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacityInt(0.8),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
