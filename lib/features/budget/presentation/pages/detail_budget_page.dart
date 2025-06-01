import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/icon/app_icon.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetailBudgetPage extends StatelessWidget {
  const DetailBudgetPage({
    super.key,
    required this.budgetEntity,
    required this.isFinished,
  });

  final BudgetEntity budgetEntity;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd/MM/yyyy');

    var color = '0xff${budgetEntity.category.color.replaceAll('#', '')}';
    double remaining = budgetEntity.amountLimit - budgetEntity.amountSpent;
    var endDate = DateTime(
      budgetEntity.endDate.year,
      budgetEntity.endDate.month,
      budgetEntity.endDate.day - 1,
    );
    var daysLeft = budgetEntity.endDate.difference(DateTime.now()).inDays;
    double value = budgetEntity.amountSpent / budgetEntity.amountLimit;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.detailBudget,
        centerTitle: true,
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                AppBottomSheet.show(
                  context: context,
                  widget: ConfirmEventBottomSheet(
                    title: AppLocalizations.of(context)!.removeThisBudget,
                    subtitle: AppLocalizations.of(context)!.confirmRemoveBudget,
                    onPressedYesButton: () {
                      context.pop();
                      context
                          .read<BudgetBloc>()
                          .add(BudgetRemoved(budgetId: budgetEntity.budgetId));
                    },
                  ),
                );
              },
              icon: SvgPicture.asset(
                AppVectors.deleteIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.dark50,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state.status == BudgetStatus.loading) {
            Loading.show(context);
          }
          if (state.status == BudgetStatus.success) {
            Loading.hide(context);
            context.pop();
          }
          if (state.status == BudgetStatus.failure) {
            Loading.hide(context);
            AppSnackBar.showError(context,
                GetLocalizedName.getLocalizedName(context, state.errorMessage));
          }
        },
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.light40,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          icon:
                              'assets/vectors/category/${budgetEntity.category.iconName}',
                          size: 36,
                          iconSize: 24,
                          iconColor: Color(int.parse(color)),
                          backgroundIconColor:
                              Color(int.parse(color)).withValues(alpha: 0.15),
                          borderRadius: 8,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          GetLocalizedName.getLocalizedName(
                            context,
                            budgetEntity.category.name,
                          ),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.dark100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    value <= 1
                        ? AppLocalizations.of(context)!.remaining
                        : AppLocalizations.of(context)!.overspent,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: value <= 1 ? AppColors.dark100 : AppColors.red100,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      CurrencyFormatter.format(
                        amount: value <= 1 ? remaining : -remaining,
                        toCurrency: state.setting.currency,
                      ),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        color:
                            value <= 1 ? AppColors.dark100 : AppColors.red100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: value > 1 ? 1 : value,
                          color: Color(int.parse(color)),
                          backgroundColor: AppColors.light40,
                          borderRadius: BorderRadius.circular(1000),
                          minHeight: 14,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.spent,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.light20,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.limit,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.light20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CurrencyFormatter.format(
                                amount: budgetEntity.amountSpent,
                                toCurrency: state.setting.currency,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.dark50,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(
                                amount: budgetEntity.amountLimit,
                                toCurrency: state.setting.currency,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.dark50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 44,
                              color: AppColors.dark50,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${dateFormat.format(budgetEntity.startDate)} - ${dateFormat.format(endDate)}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.dark50,
                                  ),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$daysLeft ${AppLocalizations.of(context)!.daysLeft}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.light20,
                                  ),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (value > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(top: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: AppColors.red100,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error,
                                  size: 32,
                                  color: AppColors.light100,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .exceededSpendingLimit,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: AppColors.light100,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!isFinished)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 32),
                      child: AppButton(
                        onPressed: () {
                          context.push(
                            RoutePaths.addOrEditBudget,
                            extra: ({
                              'isEdit': true,
                              'budget': budgetEntity,
                            }),
                          );
                        },
                        buttonText: AppLocalizations.of(context)!.editBudget,
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
