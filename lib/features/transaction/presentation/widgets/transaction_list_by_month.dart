import 'package:expense_tracker_app/core/common/extensions/date_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/group_transactions_by_date.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListByMonth extends StatelessWidget {
  const TransactionListByMonth({
    super.key,
    this.walletId,
    required this.initialDate, this.padding,
  });

  final String? walletId;
  final DateTime initialDate;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TransactionBloc, TransactionState>(
        buildWhen: (previous, current) {
          return previous.status != current.status;
        },
        builder: (context, state) {
          final transactionByMonth = walletId != null
              ? state.transactions
                  .where((e) =>
                      e.createdAt.isAfter(
                          DateTime(initialDate.year, initialDate.month, 1)) &&
                      e.createdAt.isBefore(DateTime(
                          initialDate.year, initialDate.month + 1, 1)) &&
                      e.walletId == walletId)
                  .toList()
              : state.transactions
                  .where((e) =>
                      e.createdAt.isAfter(
                          DateTime(initialDate.year, initialDate.month, 1)) &&
                      e.createdAt.isBefore(
                          DateTime(initialDate.year, initialDate.month + 1, 1)))
                  .toList();

          if(transactionByMonth.isEmpty){
            return Center(
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
            );
          }

          final grouped = GroupTransactionsByDate.groupTransactionsByDate(
              transactionByMonth);

          final dateKeys = grouped.keys.toList();
          return ListView.builder(
            padding: padding ?? const EdgeInsets.only(bottom: 32),
            itemBuilder: (context, index) {
              final date = dateKeys[index];
              final transactions = grouped[date]!
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
                      child: TransactionItem(transactionEntity: transaction),
                    ),
                  ),
                ],
              );
            },
            itemCount: dateKeys.length,
          );
        },
      ),
    );
  }
}
