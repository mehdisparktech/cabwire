import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/driver/profile/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Contact Us', showBackButton: true),
      body: Column(
        children: [
          gapH20,
          Container(
            margin: EdgeInsets.all(14),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacityInt(0.2)),
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
                CommonText(
                  text: 'Contact Us',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.primary,
                ),
                gapH20,
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
                CommonText(text: 'Message'),
                gapH10,
                CustomTextFormField(
                  hintText: 'Enter Message',
                  controller: messageController,
                ),
              ],
            ),
          ),
          Spacer(),
          CustomButton(text: 'Submit', onPressed: () {}, radius: 10),
          gapH20,
        ],
      ),
    );
  }
}
