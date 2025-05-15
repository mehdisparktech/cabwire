class AuthValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{10,}$').hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateOTP(String? value, {int digits = 6}) {
    if (value == null || value.isEmpty) {
      return 'Please enter verification code';
    }
    if (value.length != digits) {
      return 'Please enter all $digits digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter numbers only';
    }
    return null;
  }
}
