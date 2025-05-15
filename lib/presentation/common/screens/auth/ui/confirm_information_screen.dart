import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/screens/auth/ui/set_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_screen_wrapper.dart';
import '../widgets/auth_form_container.dart';
import '../widgets/auth_validators.dart';

class ConfirmInformationScreen extends StatefulWidget {
  const ConfirmInformationScreen({super.key});

  @override
  State<ConfirmInformationScreen> createState() =>
      _ConfirmInformationScreenState();
}

class _ConfirmInformationScreenState extends State<ConfirmInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _confirmInformation() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Sign in logic here
    //   print('Email: ${_emailController.text}');
    //   print('Password: ${_passwordController.text}');
    // }
    Get.to(() => SetLocationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Confirm Information",
      subtitle: "Please confirm your information to continue.",
      child: AuthFormContainer(
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _nameController,
            hintText: 'Enter Your Name',
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          gapH20,
          CustomTextFormField(
            controller: _phoneNumberController,
            hintText: 'Enter Your Phone Number',
            keyboardType: TextInputType.phone,
            validator: AuthValidators.validatePhoneNumber,
          ),
        ],
        actionButton: CustomButton(
          text: "Continue",
          onPressed: _confirmInformation,
        ),
      ),
    );
  }
}
