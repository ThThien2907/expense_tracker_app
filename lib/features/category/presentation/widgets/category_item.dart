import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/icon/app_icon.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.categoryEntity,
    this.onTap,
  });

  final CategoryEntity categoryEntity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color color = Color(int.parse('0xff${categoryEntity.color.replaceAll('#', '')}'));
    return Material(
      color: AppColors.light80,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              AppIcon(
                icon: 'assets/vectors/category/${categoryEntity.iconName}',
                size: 50,
                iconSize: 32,
                iconColor: color,
                backgroundIconColor: color.withValues(alpha: 0.15),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                GetLocalizedName.getLocalizedName(context, categoryEntity.name),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
