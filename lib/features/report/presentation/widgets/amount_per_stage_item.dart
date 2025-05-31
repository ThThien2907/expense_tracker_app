import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/date_formatter.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AmountPerStageItem extends StatelessWidget {
  const AmountPerStageItem({
    super.key,
    required this.date,
    required this.listData,
    required this.currency,
  });

  final DateTime date;
  final List<Map<DateTime, List<TransactionEntity>>> listData;
  final String currency;

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpense = 0;
    for (var data in listData) {
      for (var transaction in data.values.single) {
        if (transaction.category.type == 0) {
          totalExpense += transaction.amount;
        } else {
          totalIncome += transaction.amount;
        }
      }
    }

    var dateFormat = DateFormat('dd/MM');
    var startDate = dateFormat.format(date);
    var endDate = dateFormat.format(date.day == 26
        ? date.lastDayOfMonth()!
        : date.add(const Duration(days: 4)));

    return InkWell(
      onTap: () {
        AppBottomSheet.show(
          height: MediaQuery.of(context).size.height * .85,
          context: context,
          widget: Scaffold(
            appBar: CustomAppBar(
              title: '$startDate - $endDate',
              centerTitle: true,
            ),
            body: BlocListener<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if(state.status == TransactionStatus.success){
                  context.pop();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    final data = listData[index];
                    final date = data.keys.first;
                    final transactions = data[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, top: 12),
                          child: Text(
                            DateFormatter.formatDateLabel(context, date),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.dark75,
                            ),
                          ),
                        ),
                        ...transactions.map(
                          (transaction) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 4),
                            child:
                                TransactionItem(transactionEntity: transaction),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                '$startDate - $endDate',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.dark25,
                ),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(
                    amount: totalIncome,
                    toCurrency: currency,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.green100,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(
                    amount: totalExpense,
                    toCurrency: currency,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.red100,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(
                    amount: totalIncome - totalExpense,
                    toCurrency: currency,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.dark100,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.dark25.withValues(alpha: 0.3),
            )
          ],
        ),
      ),
    );
  }
}
