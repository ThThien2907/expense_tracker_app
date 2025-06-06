import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.widget,
    this.buttonText = 'null',
    this.buttonColor,
    this.textColor,
    this.width,
    this.height,
    this.borderSide,
  });

  final Widget? widget;
  final String buttonText;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        minimumSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 60,
        ),
        elevation: 0,
        backgroundColor: buttonColor ?? AppColors.violet100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: borderSide ?? BorderSide.none,
        ),
        overlayColor: AppColors.light100
      ),
      child: widget ?? Text(
        buttonText,
        style: TextStyle(
          fontSize: 18,
          color: textColor ?? AppColors.light80,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
