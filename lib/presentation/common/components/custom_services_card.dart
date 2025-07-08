import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/passenger/passenger_services/ui/screens/passenger_services_page.dart';
import 'package:flutter/material.dart';

class Service {
  final String title;
  final String imageUrl;
  final FontWeight fontWeight;
  final VoidCallback onTap;

  Service({
    required this.title,
    required this.imageUrl,
    required this.fontWeight,
    required this.onTap,
  });
}

class CustomServicesCard extends StatelessWidget {
  static final double _serviceCardWidth = 160.px;
  static final double _serviceCardHeight = 122.px;
  static final double _imageHeight = 60.px;
  static final double _imageWidth = 80.px;
  static const Color _primaryTextColor = Color(0xFF1E1E1E);
  static const Color _shadowColor = Color(0x3F407BFF);
  static const Color _cardShadowColor = Color(0x26000000);

  final List<Service> services;
  final bool showSeeAllButton;

  const CustomServicesCard({
    super.key,
    required this.services,
    this.showSeeAllButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.px, vertical: 20.px),
      decoration: _buildMainContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildServicesContent(),
          SizedBox(height: 4.px),
          if (showSeeAllButton) _buildSeeAllButton(context),
        ],
      ),
    );
  }

  ShapeDecoration _buildMainContainerDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadows: const [
        BoxShadow(color: _shadowColor, blurRadius: 4, offset: Offset.zero),
      ],
    );
  }

  Widget _buildServicesContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 10.px),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.px),
          height: _serviceCardHeight * (services.length / 2).ceil() + 16.px,
          child: GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // Disable inner scroll
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              mainAxisSpacing: 13,
              crossAxisSpacing: 13,
              childAspectRatio: _serviceCardWidth / _serviceCardHeight,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(
                title: service.title,
                imageUrl: service.imageUrl,
                fontWeight: service.fontWeight,
                onTap: service.onTap,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      'Our Services',
      style: TextStyle(
        color: _primaryTextColor,
        fontSize: 16.px,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String imageUrl,
    required FontWeight fontWeight,
    required VoidCallback onTap,
  }) {
    return Container(
      width: _serviceCardWidth,
      height: _serviceCardHeight,
      decoration: _buildCardDecoration(),
      child: _buildCardContent(title, imageUrl, fontWeight, onTap),
    );
  }

  ShapeDecoration _buildCardDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.px)),
      shadows: const [
        BoxShadow(color: _cardShadowColor, blurRadius: 4, offset: Offset.zero),
      ],
    );
  }

  Widget _buildCardContent(
    String title,
    String imageUrl,
    FontWeight fontWeight,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.px, vertical: 12.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonImage(
              imageSrc: imageUrl,
              imageType: ImageType.network,
              width: _imageWidth,
              height: _imageHeight,
            ),
            SizedBox(height: 6.px),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.px,
                fontWeight: fontWeight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PassengerServicesPage(),
          ),
        );
      },
      child: Text(
        'See All',
        style: TextStyle(
          color: _primaryTextColor,
          fontSize: 12.px,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
    );
  }
}
