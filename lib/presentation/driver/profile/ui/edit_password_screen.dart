import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/common/components/auth/custom_text_form_field.dart';
import 'package:cabwire/presentation/common/components/custom_app_bar.dart';
import 'package:cabwire/presentation/common/components/common_text.dart';
import 'package:flutter/material.dart';

class EditPasswordScreen extends StatelessWidget {
  EditPasswordScreen({super.key});
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Password', showBackButton: true),
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
                  text: 'Change Password',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                gapH20,
                CommonText(text: 'Old Password'),
                gapH10,
                CustomTextFormField(
                  hintText: 'Enter Old Password',
                  controller: oldPasswordController,
                ),
                gapH10,
                CommonText(text: 'New Password'),
                gapH10,
                CustomTextFormField(
                  hintText: 'Enter New Password',
                  controller: newPasswordController,
                ),
                gapH10,
                CommonText(text: 'Confirm New Password'),
                gapH10,
                CustomTextFormField(
                  hintText: 'Confirm New Password',
                  controller: confirmNewPasswordController,
                ),
                gapH10,
              ],
            ),
          ),
          Spacer(),
          CustomButton(text: 'Save', onPressed: () {}, radius: 10),
          gapH20,
        ],
      ),
    );
  }
}
