import 'package:cabwire/core/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateTimeHelper {
  static Future<String> openDatePickerDialog(
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: AppColor.primary),
            ),
            child: child!,
          ),
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      controller.text = "${picked.year}/${picked.month}/${picked.day}";
      return picked.toIso8601String();
    }
    return "";
  }

  static Future<String> openTimePickerDialog(
    TextEditingController? controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final String formattedTime = formatTime(picked);
      controller?.text = formattedTime;
      return formattedTime;
    }
    return '';
  }

  static String formatTime(TimeOfDay time) {
    return "${time.hour > 12 ? (time.hour - 12).toString().padLeft(2, '0') : (time.hour == 0 ? 12 : time.hour).toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? "PM" : "AM"}";
  }
}
