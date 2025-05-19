import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/home/widgets/ride_action_button.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Post'),
      body: Center(
        child: Column(
          children: [
            CommonImage(
              imageType: ImageType.png,
              imageSrc: AppAssets.icCarCreatePost,
              width: 200,
              height: 200,
            ),
            CustomText(
              'Book Your Car Seat for Passengers! ',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              'Ensure a comfortable and safe ride by making sure your car seat is ready for passengers. Reserve your seat in advance and offer a hassle-free experience to those you drive. Book now and be prepared! ',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.theme.colorScheme.onSurface,
            ),
            gapH25,
            RideActionButton(
              text: 'Book Now',
              isPrimary: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
