import 'package:expense_tracker_app/core/common/cubits/type/selected_type_cubit.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/generate_chart_data.dart';
import 'package:expense_tracker_app/core/common/extensions/group_transactions.dart';
import 'package:expense_tracker_app/core/common/widgets/toggle/page_view_toggle.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/report/presentation/widgets/amount_per_stage_item.dart';
import 'package:expense_tracker_app/features/report/presentation/widgets/line_chart_report.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/cubit/selected_wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LineChartReportPage extends StatelessWidget {
  const LineChartReportPage({
    super.key,
    required this.initialDate,
  });

  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    final setting = context.read<SettingBloc>().state.setting;
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, transactionState) {
        return BlocBuilder<SelectedWalletCubit, WalletEntity?>(
          builder: (context, walletState) {
            final transactionsByMonth = transactionState.transactions
                .where(
                  (e) =>
                      e.createdAt.isAfter(DateTime(initialDate.year, initialDate.month, 1)) &&
                      e.createdAt.isBefore(DateTime(initialDate.year, initialDate.month + 1, 1)) &&
                      (walletState!.walletId == 'total' || e.walletId == walletState.walletId),
                )
                .toList();

            final lineChartData = GenerateChartData.generateLineChartData(
              transactions: transactionsByMonth,
              currency: setting.currency,
              month: initialDate,
            );

            final groupedByStage = GroupTransactions.groupTransactionsByStage(transactionsByMonth);

            final dateKeys = groupedByStage.keys.toList();

            return Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    _buildTotalAmountItem(
                      context,
                      AppLocalizations.of(context)!.totalIncome,
                      lineChartData['income']['totalAmount'],
                      AppColors.green100,
                    ),
                    _buildTotalAmountItem(
                      context,
                      AppLocalizations.of(context)!.totalExpense,
                      lineChartData['expense']['totalAmount'],
                      AppColors.red100,
                    ),
                    _buildTotalAmountItem(
                      context,
                      AppLocalizations.of(context)!.difference,
                      lineChartData['income']['totalAmount'] -
                          lineChartData['expense']['totalAmount'],
                      AppColors.dark75,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<SelectedTypeCubit, int>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            LineChartReport(
                              chartData:
                                  state == 0 ? lineChartData['expense'] : lineChartData['income'],
                              isExpense: state == 0,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            PageViewToggle(
                              labels: [
                                AppLocalizations.of(context)!.expense,
                                AppLocalizations.of(context)!.income
                              ],
                              selectedIndex: state,
                              onItemSelected: (index) {
                                context.read<SelectedTypeCubit>().setType(index);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    groupedByStage.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.only(bottom: 16),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dateKeys.length,
                            itemBuilder: (context, index) {
                              return AmountPerStageItem(
                                date: dateKeys[index],
                                listData: groupedByStage[dateKeys[index]]!,
                                currency: setting.currency,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: AppColors.light40,
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 48),
                            child: Text(
                              AppLocalizations.of(context)!.doNotHaveTransactionsThisMonth,
                              style: const TextStyle(
                                color: AppColors.light20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTotalAmountItem(
    BuildContext context,
    String label,
    double amount,
    Color amountColor,
  ) {
    final setting = context.read<SettingBloc>().state.setting;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.dark75,
          ),
        ),
        Text(
          CurrencyFormatter.format(
            amount: amount,
            toCurrency: setting.currency,
            fromCurrency: setting.currency,
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
