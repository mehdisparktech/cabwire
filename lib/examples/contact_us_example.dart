import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/domain/usecases/driver/driver_contact_usecase.dart';
import 'package:flutter/material.dart';

/// Example of how to use the Contact Us feature in a controller or bloc
class ContactUsController {
  final DriverContactUseCase _contactUseCase = locate<DriverContactUseCase>();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Loading state
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // Submit form method
  Future<void> submitContactForm() async {
    // Validate inputs
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        subjectController.text.isEmpty ||
        messageController.text.isEmpty) {
      errorMessage = 'Please fill in all required fields';
      return;
    }

    // Set loading state
    isLoading = true;

    // Create parameters for the use case
    final params = DriverContactParams(
      fullName: nameController.text,
      email: emailController.text,
      phone: phoneController.text, // Optional
      subject: subjectController.text,
      description: messageController.text,
      status: true,
    );

    // Call the use case
    final result = await _contactUseCase(params);

    // Handle the result
    result.fold(
      (error) {
        errorMessage = error;
        successMessage = null;
      },
      (_) {
        successMessage = 'Your message has been sent successfully!';
        errorMessage = null;
        _clearForm();
      },
    );

    // Update loading state
    isLoading = false;
  }

  // Clear form fields
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    subjectController.clear();
    messageController.clear();
  }

  // Don't forget to dispose controllers
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    messageController.dispose();
  }
}
