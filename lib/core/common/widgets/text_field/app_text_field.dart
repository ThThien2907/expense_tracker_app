import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.hintStyle,
    this.textStyle,
    this.maxLength,
  });

  final TextEditingController? controller;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
      ),
      style: textStyle ?? const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.dark100,
        fontSize: 16,
      ),
      maxLength: maxLength,
    );
  }
}
