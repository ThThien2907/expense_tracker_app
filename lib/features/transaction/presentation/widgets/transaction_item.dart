import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/date_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/icon/app_icon.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transactionEntity,
    this.isShowCreatedAt = false,
  });

  final TransactionEntity transactionEntity;
  final bool isShowCreatedAt;

  @override
  Widget build(BuildContext context) {
    bool isExpense = transactionEntity.category.type == 0;
    Color color = Color(int.parse(
        '0xff${transactionEntity.category.color.replaceAll('#', '')}'));

    return Material(
      color: AppColors.light80,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          context.push(
            RoutePaths.detailTransaction,
            extra: ({
              'transaction': transactionEntity,
            }),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: Row(
            children: [
              AppIcon(
                icon:
                    'assets/vectors/category/${transactionEntity.category.iconName}',
                size: 60,
                iconSize: 40,
                iconColor: color,
                backgroundIconColor: color.withValues(alpha: 0.15),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            GetLocalizedName.getLocalizedName(
                              context,
                              transactionEntity.category.name,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: AppColors.dark25,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        BlocBuilder<SettingBloc, SettingState>(
                          builder: (context, state) {
                            return Text(
                              '${isExpense ? '-' : '+'} ${CurrencyFormatter.format(
                                amount: transactionEntity.amount,
                                toCurrency: state.setting.currency,
                              )}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: isExpense
                                    ? AppColors.red100
                                    : AppColors.green100,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            transactionEntity.description,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.light20,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          isShowCreatedAt
                              ? DateFormatter.formatDateLabel(
                                  context, transactionEntity.createdAt)
                              : '',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.light20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
