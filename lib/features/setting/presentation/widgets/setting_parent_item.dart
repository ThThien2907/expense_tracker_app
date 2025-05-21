import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingParentItem extends StatelessWidget {
  const SettingParentItem({
    super.key,
    required this.settingName,
    required this.selectedSetting,
    required this.onTap,
  });

  final String settingName;
  final String selectedSetting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        child: Row(
          children: [
            Text(
              settingName,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.dark25,
              ),
            ),
            const Spacer(),
            Text(
              selectedSetting,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.light20,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.violet100,
            )
          ],
        ),
      ),
    );
  }
}
