import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:cabwire/presentation/driver/create_post/ui/search_destination_page.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Post'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonImage(
            imageType: ImageType.png,
            imageSrc: AppAssets.icCarCreatePost,
            width: double.infinity,
            height: 300,
          ),
          gapH20,
          CustomText(
            'Book Your Car Seat for\n Passengers! ',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          gapH10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(
              'Ensure a comfortable and safe ride by making sure your car seat is ready for passengers. Reserve your seat in advance and offer a hassle-free experience to those you drive. Book now and be prepared! ',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.theme.colorScheme.onSurface,
              textAlign: TextAlign.justify,
            ),
          ),
          gapH60,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ActionButton(
              text: 'Create New Post',
              isPrimary: true,
              onPressed: () {
                Get.to(() => const SearchDestinationScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}
