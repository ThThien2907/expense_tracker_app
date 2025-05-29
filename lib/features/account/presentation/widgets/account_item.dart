import 'package:expense_tracker_app/core/common/widgets/icon/app_icon.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {
  const AccountItem(
      {super.key,
      this.borderRadius,
      this.onTap,
      required this.icon,
      required this.label,
      this.iconColor,
      this.backgroundIconColor});

  final BorderRadius? borderRadius;
  final Function()? onTap;
  final String icon;
  final String label;
  final Color? iconColor;
  final Color? backgroundIconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.light100,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              AppIcon(
                icon: icon,
                size: 52,
                iconSize: 32,
                backgroundIconColor: backgroundIconColor,
                iconColor: iconColor,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
