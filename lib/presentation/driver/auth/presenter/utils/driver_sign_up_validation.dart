import 'package:flutter/material.dart';

class DriverSignUpValidation {
  // Form validation
  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  // Password validation
  bool validatePasswords(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Email masking for verification screen
  String getMaskedEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return email;
    return email.replaceRange(3, email.indexOf('@'), '...');
  }

  // Email format validation
  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Password strength validation
  bool isStrongPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  // Phone number validation
  bool isValidPhoneNumber(String phoneNumber) {
    // Basic phone number validation (adjust pattern as needed)
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber);
  }

  // License number validation
  bool isValidLicenseNumber(String licenseNumber) {
    // Basic license number validation (adjust as per your requirements)
    return licenseNumber.length >= 6 &&
        RegExp(r'^[A-Za-z0-9]+$').hasMatch(licenseNumber);
  }

  // Vehicle registration number validation
  bool isValidRegistrationNumber(String registrationNumber) {
    // Basic registration number validation
    return registrationNumber.isNotEmpty && registrationNumber.length >= 4;
  }

  // Age validation based on date of birth
  bool isValidAge(DateTime dateOfBirth, int minimumAge) {
    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      return age - 1 >= minimumAge;
    }
    return age >= minimumAge;
  }

  // License expiry date validation
  bool isValidLicenseExpiryDate(DateTime expiryDate) {
    return expiryDate.isAfter(DateTime.now());
  }

  // Vehicle year validation
  bool isValidVehicleYear(String year) {
    try {
      final yearInt = int.parse(year);
      final currentYear = DateTime.now().year;
      return yearInt >= 1900 && yearInt <= currentYear + 1;
    } catch (e) {
      return false;
    }
  }

  // Name validation
  bool isValidName(String name) {
    return name.trim().length >= 2 &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim());
  }

  // Generic required field validation
  bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
}
