import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';

class Service {
  final String title;
  final String imageUrl;
  final FontWeight fontWeight;

  Service({
    required this.title,
    required this.imageUrl,
    required this.fontWeight,
  });
}

class ServicesWidget extends StatelessWidget {
  static final double _containerWidth = 357.px;
  static final double _serviceCardWidth = 160.px;
  static final double _serviceCardHeight = 122.px;
  static final double _imageHeight = 60.px;
  static final double _imageWidth = 80.px;
  static const Color _primaryTextColor = Color(0xFF1E1E1E);
  static const Color _shadowColor = Color(0x3F407BFF);
  static const Color _cardShadowColor = Color(0x26000000);

  final List<Service> services;

  const ServicesWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _containerWidth,
      padding: EdgeInsets.symmetric(horizontal: 13.px, vertical: 20.px),
      decoration: _buildMainContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildServicesContent(),
          SizedBox(height: 10.px),
          _buildSeeAllButton(),
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
        SizedBox(
          height:
              _serviceCardHeight * 2 + 13, // Enough height for 2 rows + spacing
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
  }) {
    return Container(
      width: _serviceCardWidth,
      height: _serviceCardHeight,
      decoration: _buildCardDecoration(),
      child: _buildCardContent(title, imageUrl, fontWeight),
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
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.px, vertical: 12.px),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            imageSrc: imageUrl,
            imageType: ImageType.png,
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
    );
  }

  Widget _buildSeeAllButton() {
    return GestureDetector(
      onTap: () {
        // ignore: avoid_print
        print('See All tapped');
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
