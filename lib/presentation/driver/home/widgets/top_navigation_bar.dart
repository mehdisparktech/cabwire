import 'package:cabwire/core/utility/utility.dart';
import 'package:flutter/material.dart';
// If you decide to use GetX for theming directly in this widget, uncomment:
// import 'package:get/get.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // The original margin was commented out in the previous refactor.
        // You can add it back if needed for specific spacing from screen edges
        // when not constrained by other elements.
        // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Consider using a theme color for better consistency, e.g.:
          // color: Theme.of(context).colorScheme.secondaryContainer,
          // Or if using GetX and have themes defined:
          // color: context.theme.colorScheme.secondaryContainer,
          color: const Color(0xFFFFD5A9),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_forward, size: 20),
            const SizedBox(width: 8),
            const Text(
              '200 m',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Turn right at block b, road no 18',
                style: TextStyle(
                  fontSize: 14,
                  // Consider using a theme text color if appropriate:
                  // color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                  color: Colors.black.withOpacityInt(0.8),
                ),
                overflow:
                    TextOverflow.ellipsis, // Handles text that is too long
                maxLines:
                    1, // Ensures the text stays on a single line, adjust if multi-line is desired
              ),
            ),
          ],
        ),
      ),
    );
  }
}
