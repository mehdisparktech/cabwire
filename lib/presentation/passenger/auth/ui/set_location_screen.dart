import 'package:cabwire/presentation/passenger/auth/ui/auth_navigator_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_screen_wrapper.dart';
import '../widgets/auth_form_container.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _setLocation() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   // Set location logic
    //   Get.to(() => LoginScreen(toggleView: () {}));
    // }
    Get.to(() => AuthNavigationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      title: "Set Location",
      subtitle: "Please set your location to continue.",
      child: AuthFormContainer(
        formKey: _formKey,
        formFields: [
          CustomTextFormField(
            controller: _locationController,
            hintText: 'Enter a new address',
            prefixIcon: const Icon(Icons.location_on),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new address';
              }
              return null;
            },
          ),
        ],
        actionButton: CustomButton(text: "Complete", onPressed: _setLocation),
      ),
    );
  }
}
