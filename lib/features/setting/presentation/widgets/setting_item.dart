import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.name,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  final String name;
  final String value;
  final String selectedValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.dark100,
              ),
            ),
            if (value == selectedValue)
              const Icon(
                Icons.check,
                color: AppColors.violet100,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
