import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Loading {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.light100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.violet100,
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
