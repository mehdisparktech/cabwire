import 'package:flutter/material.dart';

// Simple model class for car service data
class CarService {
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  const CarService({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

// Main widget class with all functionality in one place
class CarServiceCard extends StatelessWidget {
  final CarService service;
  final VoidCallback? onTap;
  final double? width;
  final String currency;

  const CarServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.width = 358,
    this.currency = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: _buildCardDecoration(),
        child: Row(
          children: [
            _buildCarImage(),
            const SizedBox(width: 15),
            Expanded(child: _buildCarDetails(context)),
            const SizedBox(width: 30),
            _buildPrice(context),
          ],
        ),
      ),
    );
  }

  // Builder method for card decoration - keeps styling logic organized
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x26000000), // 15% opacity for subtle shadow
          blurRadius: 4,
          offset: Offset.zero,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Builder method for car image with oval background and error handling
  Widget _buildCarImage() {
    return Container(
      width: 90,
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9), // Light gray background for contrast
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          6,
        ), // Inner padding to create border effect
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6), // Rounded corners for image
          child: Image.network(
            service.imageUrl,
            fit: BoxFit.cover,
            width: 78, // Calculated to fit inside circle with padding
            height: 48,
            // Error handling - shows car icon if image fails to load
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.directions_car, color: Colors.grey),
              );
            },
            // Loading state - shows progress indicator while image loads
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Builder method for car details section - name and description
  Widget _buildCarDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Car service name with theme-aware styling
        Text(
          service.name,
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1E1E1E),
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
              ) ??
              _getDefaultTitleStyle(), // Fallback if theme is not available
        ),
        const SizedBox(
          height: 5,
        ), // Consistent spacing between title and description
        // Service description with smaller font
        Text(
          service.description,
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF1E1E1E),
                fontFamily: 'Outfit',
              ) ??
              _getDefaultBodyStyle(), // Fallback styling
        ),
      ],
    );
  }

  // Builder method for price display with currency formatting
  Widget _buildPrice(BuildContext context) {
    return Text(
      '$currency${service.price.toStringAsFixed(0)}', // Format price without decimal places
      style:
          Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E1E1E),
            fontWeight: FontWeight.w700,
            fontFamily: 'Outfit',
          ) ??
          _getDefaultTitleStyle(),
    );
  }

  // Helper method for default title styling - ensures consistency
  TextStyle _getDefaultTitleStyle() {
    return const TextStyle(
      color: Color(0xFF1E1E1E),
      fontSize: 18,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
  }

  // Helper method for default body text styling
  TextStyle _getDefaultBodyStyle() {
    return const TextStyle(
      color: Color(0xFF1E1E1E),
      fontSize: 12,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }
}
