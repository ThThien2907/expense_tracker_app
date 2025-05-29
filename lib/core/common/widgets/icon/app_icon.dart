import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.iconColor,
    this.backgroundIconColor,
    required this.icon,
    required this.size,
    required this.iconSize,
    this.borderRadius,
  });

  final Color? iconColor;
  final Color? backgroundIconColor;
  final String icon;
  final double size;
  final double iconSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundIconColor ?? AppColors.violet20,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        height: iconSize,
        colorFilter: ColorFilter.mode(
          iconColor ?? AppColors.violet100,
          BlendMode.srcIn,
        ),
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.error,
            size: iconSize,
            color: iconColor ?? AppColors.violet100,
          );
        },
        placeholderBuilder: (context) {
          return Icon(
            Icons.cached,
            size: iconSize,
            color: iconColor ?? AppColors.violet100,
          );
        },
      ),
    );
  }
}
