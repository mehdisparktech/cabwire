import 'package:flutter/material.dart';
import 'driver_sign_up_constants.dart';

class DriverSignUpUIHelpers {
  // Date picker for date of birth
  Future<DateTime?> showDateOfBirthPicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        Duration(days: 365 * DriverSignUpConstants.minAge),
      ),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      fieldHintText: 'Enter date of birth',
      fieldLabelText: 'Date of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // Date picker for license expiry
  Future<DateTime?> showLicenseExpiryDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 365 * DriverSignUpConstants.maxLicenseValidityYears),
      ),
      helpText: 'Select License Expiry Date',
      fieldHintText: 'Enter license expiry date',
      fieldLabelText: 'License Expiry Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // Format date to string
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Format date with month name
  String formatDateWithMonth(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  // Show selection sheet (for gender, vehicle category, etc.)
  void showSelectionSheet(
    BuildContext context,
    List<String> options,
    TextEditingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Select Option',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                // Options list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return ListTile(
                        title: Text(
                          option,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing:
                            controller.text == option
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                        onTap: () {
                          controller.text = option;
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                // Bottom padding
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  // Show confirmation dialog
  Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelText),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
            ],
          ),
    );
  }

  // Show error dialog
  Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(buttonText),
              ),
            ],
          ),
    );
  }

  // Show success dialog
  Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: onPressed ?? () => Navigator.pop(context),
                child: Text(buttonText),
              ),
            ],
          ),
    );
  }

  // Show loading dialog
  void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(message),
              ],
            ),
          ),
    );
  }

  // Hide loading dialog
  void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Show snackbar
  void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  // Show image picker options
  void showImagePickerOptions(
    BuildContext context, {
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onCameraPressed();
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onGalleryPressed();
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  // Focus next field
  void focusNextField(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Dismiss keyboard
  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
