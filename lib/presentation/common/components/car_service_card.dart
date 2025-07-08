import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';

// Simple model class for car service data
class CarService {
  final String name;
  final String description;
  final String imageUrl;
  final String imageBackground;
  final double price;
  final String id; // Add id for identification

  const CarService({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.imageBackground,
    required this.price,
    this.id = '',
  });
}

// Main widget class with all functionality in one place
class CarServiceCard extends StatelessWidget {
  final CarService service;
  final VoidCallback? onTap;
  final double? width;
  final String currency;
  final bool isSelected;

  const CarServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.width = 358,
    this.currency = '\$',
    this.isSelected = false,
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
      border:
          isSelected
              ? Border.all(color: const Color(0xFF2196F3), width: 2.0)
              : null,
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
    // Determine if the image URL is a network URL
    final bool isNetworkImage = service.imageUrl.startsWith('http');

    return Padding(
      padding: const EdgeInsets.all(6), // Inner padding to create border effect
      child: Stack(
        alignment: Alignment.center,
        children: [
          CommonImage(
            imageSrc: service.imageBackground,
            imageType: ImageType.svg,
            width: 90,
            height: 64,
          ),
          CommonImage(
            imageSrc: service.imageUrl,
            imageType: isNetworkImage ? ImageType.network : ImageType.png,
            width: 78,
            height: 49,
          ),
        ],
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
