import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({
    super.key,
    required this.budgetEntity,
    required this.isFinished,
  });

  final BudgetEntity budgetEntity;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd/MM');

    var color = '0xff${budgetEntity.category.color.replaceAll('#', '')}';
    double remaining = budgetEntity.amountLimit - budgetEntity.amountSpent;
    var endDate = DateTime(
      budgetEntity.endDate.year,
      budgetEntity.endDate.month,
      budgetEntity.endDate.day - 1,
    );
    double value = budgetEntity.amountSpent / budgetEntity.amountLimit;

    return Material(
      color: AppColors.light80,
      borderRadius: BorderRadius.circular(16),
      elevation: 5,
      shadowColor: AppColors.dark100.withValues(alpha: 0.3),
      child: InkWell(
        onTap: () {
          context.push(RoutePaths.detailBudget,
              extra: ({
                'budget': budgetEntity,
                'isFinished': isFinished,
              }));
        },
        borderRadius: BorderRadius.circular(16),
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (value > 1)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.error,
                            color: AppColors.red100,
                            size: 28,
                          ),
                        ),
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
                              GetLocalizedName.getLocalizedName(
                                  context, budgetEntity.category.name),
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
                      Expanded(
                        child: Text(
                          '${dateFormat.format(budgetEntity.startDate)} - ${dateFormat.format(endDate)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.light20,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    value <= 1
                        ? '${AppLocalizations.of(context)!.remaining} ${CurrencyFormatter.format(
                            amount: remaining,
                            toCurrency: state.setting.currency,
                          )}'
                        : '${AppLocalizations.of(context)!.overspent} ${CurrencyFormatter.format(
                            amount: -remaining,
                            toCurrency: state.setting.currency,
                          )}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: value <= 1 ? AppColors.dark50 : AppColors.red100,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LinearProgressIndicator(
                    value: value > 1 ? 1 : value,
                    color: Color(int.parse(color)),
                    backgroundColor: AppColors.light40,
                    borderRadius: BorderRadius.circular(1000),
                    minHeight: 14,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.light20,
                      ),
                      children: [
                        TextSpan(
                          text: CurrencyFormatter.format(
                            amount: budgetEntity.amountSpent,
                            toCurrency: state.setting.currency,
                          ),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context)!.budgetOf} ',
                        ),
                        TextSpan(
                          text: CurrencyFormatter.format(
                            amount: budgetEntity.amountLimit,
                            toCurrency: state.setting.currency,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (value > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        AppLocalizations.of(context)!.exceededSpendingLimit,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.red100,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
