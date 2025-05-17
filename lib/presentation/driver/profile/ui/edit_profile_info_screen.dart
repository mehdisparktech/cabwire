import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_image.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_text.dart';
import 'package:flutter/material.dart';

class EditProfileInfoScreen extends StatelessWidget {
  EditProfileInfoScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Change Profile Information',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    gapH20,
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: CommonImage(
                              imageType: ImageType.png,
                              imageSrc: AppAssets.icProfileImage,
                              fill: BoxFit.cover,
                              width: 160,
                              height: 160,
                              borderRadius: 100,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    gapH20,
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withOpacityInt(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacityInt(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(text: 'Name'),
                          gapH10,
                          CustomTextFormField(
                            hintText: 'Enter Name',
                            controller: nameController,
                          ),
                          gapH10,
                          CommonText(text: 'Email'),
                          gapH10,
                          CustomTextFormField(
                            hintText: 'Enter Email',
                            controller: emailController,
                          ),
                          gapH10,
                          CommonText(text: 'Phone Number'),
                          gapH10,
                          CustomTextFormField(
                            hintText: 'Enter Phone Number',
                            controller: phoneNumberController,
                          ),
                          gapH10,
                          CommonText(text: 'Date of Birth'),
                          gapH10,
                          CustomTextFormField(
                            hintText: 'Enter Date of Birth',
                            controller: addressController,
                          ),
                          gapH10,
                          CommonText(text: 'Gender'),
                          gapH10,
                          CustomTextFormField(
                            hintText: 'Enter Gender',
                            controller: genderController,
                          ),
                        ],
                      ),
                    ),
                    gapH20,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(text: 'Save', onPressed: () {}, radius: 10),
            ),
          ],
        ),
      ),
    );
  }
}
