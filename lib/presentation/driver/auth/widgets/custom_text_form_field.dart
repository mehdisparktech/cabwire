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
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureTextValue = false,
    this.onVisibilityToggle,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? obscureTextValue : false,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
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
                : suffixIcon,
      ),
    );
  }
}
