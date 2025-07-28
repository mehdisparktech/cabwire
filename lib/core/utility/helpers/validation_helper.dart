import 'package:cabwire/core/static/app_strings.dart';
import 'package:flutter/material.dart';

class ValidationHelper {
  static RegExp emailRegexp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static RegExp passRegExp = RegExp(r'(?=.*[a-z])(?=.*[0-9])');

  static String? validator(value) {
    if (value.isEmpty) {
      return AppStrings.thisFieldIsRequired;
    }
    return null;
  }

  static String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return AppStrings.thisFieldIsRequired;
    } else if (!emailRegexp.hasMatch(value)) {
      return AppStrings.enterValidEmail;
    }
    return null;
  }

  static String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return AppStrings.thisFieldIsRequired;
    } else if (value.length < 8) {
      return AppStrings.passwordMustBeeEightCharacters;
    } else if (!passRegExp.hasMatch(value)) {
      return AppStrings.passwordMustBeeEightCharacters;
    }
    return null;
  }

  static String? confirmPasswordValidator(
    value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return AppStrings.thisFieldIsRequired;
    } else if (value != passwordController.text) {
      return AppStrings.thePasswordDoesNotMatch;
    }
    return null;
  }
}
