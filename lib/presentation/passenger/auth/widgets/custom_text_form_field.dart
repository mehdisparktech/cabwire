import 'package:flutter/material.dart';
import '../../../../core/static/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool obscureTextValue;
  final VoidCallback? onVisibilityToggle;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureTextValue = false,
    this.onVisibilityToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? obscureTextValue : false,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        // Border, contentPadding, hintStyle are now primarily handled by InputDecorationTheme
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureTextValue ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: onVisibilityToggle,
                )
                : null,
      ),
    );
  }
}
