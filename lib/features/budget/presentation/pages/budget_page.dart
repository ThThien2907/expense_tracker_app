import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/widgets/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.budgets,
        centerTitle: true,
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton(
              color: AppColors.light80,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(
                    AppLocalizations.of(context)!.finishedBudget,
                  ),
                  onTap: () {
                    context.push(RoutePaths.finishedBudget);
                  },
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  var budgets = [...state.budgets];

                  var runningBudgets = budgets
                      .where((budget) => budget.endDate.isAfter(DateTime.now()))
                      .toList();

                  if (runningBudgets.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.doNotHaveBudget,
                          style: const TextStyle(
                            color: AppColors.light20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .startSavingMoneyByCreatingBudgets,
                          style: const TextStyle(
                            color: AppColors.light20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    itemBuilder: (context, index) {
                      return BudgetItem(
                        budgetEntity: runningBudgets[index],
                        isFinished: false,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 16,
                      );
                    },
                    itemCount: runningBudgets.length,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AppButton(
              onPressed: () {
                context.push(
                  RoutePaths.addOrEditBudget,
                  extra: ({
                    'isEdit': false,
                  }),
                );
              },
              buttonText: AppLocalizations.of(context)!.addNewBudget,
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
