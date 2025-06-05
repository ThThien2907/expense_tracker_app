import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SnackBarCustom extends StatelessWidget {
  const SnackBarCustom({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            content,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.light100,
            ),
            maxLines: 3,
          ),
        ),
        Padding(
          padding:  const EdgeInsets.only(left: 16,),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(
              Icons.close,
              color: AppColors.light100,
            ),
          ),
        ),
      ],
    );
  }
}

class AppSnackBar {
  static void showError(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: SnackBarCustom(
            content: content,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static void showSuccess(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: SnackBarCustom(
            content: content,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
