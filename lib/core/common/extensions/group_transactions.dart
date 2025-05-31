import 'package:collection/collection.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';

class GroupTransactions {
  GroupTransactions._();

  static Map<DateTime, List<TransactionEntity>> groupTransactionsByDate(
    List<TransactionEntity> transactions,
  ) {
    final grouped = groupBy(
      transactions,
      (TransactionEntity transaction) => DateTime(
        transaction.createdAt.year,
        transaction.createdAt.month,
        transaction.createdAt.day,
      ),
    );
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Map.fromEntries(sortedEntries);
  }

  static Map<DateTime, List<Map<DateTime, List<TransactionEntity>>>> groupTransactionsByStage(
    List<TransactionEntity> transactions,
  ) {
    final grouped = groupTransactionsByDate(transactions);
    final Map<DateTime, List<Map<DateTime, List<TransactionEntity>>>> data = {};

    for (var date in grouped.keys.toList()){
      DateTime startDay = DateTime(date.year, date.month, 1);
      if (date.day <= 5) {
        startDay = startDay.copyWith(day: 1);
      } else if (date.day <= 10) {
        startDay = startDay.copyWith(day: 6);
      } else if (date.day <= 15) {
        startDay = startDay.copyWith(day: 11);
      } else if (date.day <= 20) {
        startDay = startDay.copyWith(day: 16);
      } else if (date.day <= 25) {
        startDay = startDay.copyWith(day: 21);
      } else {
        startDay = startDay.copyWith(day: 26);
      }
      if (!data.containsKey(startDay)) {
        data[startDay] = [];
      }
      data[startDay]?.add({
        date: grouped[date]!,
      });
    }

    return data;
  }

  static Map<String, List<TransactionEntity>> groupTransactionsByCategory(
    List<TransactionEntity> transactions,
  ) {
    final grouped = groupBy(
      transactions,
      (TransactionEntity transaction) => transaction.categoryId,
    );
    return grouped;
  }
}
