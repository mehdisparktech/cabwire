import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double height;
  final VoidCallback? onBackPressed;
  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.centerTitle = true,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.height = kToolbarHeight,
    this.onBackPressed,
  }) : preferredSize = Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading:
          showBackButton
              ? IconButton(
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              )
              : null,
      actions: actions ?? [],
    );
  }
}
