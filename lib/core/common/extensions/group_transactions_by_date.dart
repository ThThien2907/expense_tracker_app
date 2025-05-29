import 'package:collection/collection.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';

class GroupTransactionsByDate {
  GroupTransactionsByDate._();

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
}
