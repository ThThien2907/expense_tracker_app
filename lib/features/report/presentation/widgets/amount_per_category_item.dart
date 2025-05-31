import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmountPerCategoryItem extends StatelessWidget {
  const AmountPerCategoryItem(
      {super.key, required this.data, required this.totalAmount});

  final Map<String, dynamic> data;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    final setting = context.read<SettingBloc>().state.setting;

    final category = data['category'] as CategoryEntity;
    final totalAmountOfCategory = data['totalAmountOfCategory'] as double;

    final color = '0xff${category.color.replaceAll('#', '')}';
    double value = totalAmountOfCategory / totalAmount;
    final type = category.type;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.light40,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color)),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      GetLocalizedName.getLocalizedName(context, category.name),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.dark50,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                (type == 0 ? '- ' : '+ ') + CurrencyFormatter.format(amount: totalAmountOfCategory, toCurrency: setting.currency),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: type == 0 ? AppColors.red100 : AppColors.green100,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          LinearProgressIndicator(
            value: value,
            color: Color(int.parse(color)),
            backgroundColor: AppColors.light40,
            borderRadius: BorderRadius.circular(1000),
            minHeight: 14,
          ),
        ],
      ),
    );
  }
}
