import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.widget,
    this.action,
    this.height,
    this.centerTitle,
    this.titleColor,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String? title;
  final Widget? widget;
  final List<Widget>? action;
  final double? height;
  final bool? centerTitle;
  final Color? titleColor;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget ??
          Text(
            title!,
            style: TextStyle(
              color: titleColor ?? AppColors.dark100,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
      foregroundColor: foregroundColor ?? AppColors.dark100,
      backgroundColor: backgroundColor,
      toolbarHeight: height ?? 60,
      actions: action,
      scrolledUnderElevation: 0.0,
      centerTitle: centerTitle ?? false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 60);
}
