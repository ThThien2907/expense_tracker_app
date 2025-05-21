import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/budget/presentation/widgets/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishedBudgetPage extends StatelessWidget {
  const FinishedBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.finishedBudget,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            var budgets = [...state.budgets];

            var finishedBudgets = budgets
                .where((budget) => budget.endDate.isBefore(DateTime.now()))
                .toList();
            if (finishedBudgets.isEmpty) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.doNotHaveBudget,
                  style: const TextStyle(
                    color: AppColors.light20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                return BudgetItem(
                  budgetEntity: finishedBudgets[index],
                  isFinished: true,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemCount: finishedBudgets.length,
            );
          },
        ),
      ),
    );
  }
}
