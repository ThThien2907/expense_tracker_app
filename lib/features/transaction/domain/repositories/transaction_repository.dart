import 'package:dartz/dartz.dart';

abstract class TransactionRepository {
  Future<Either> loadTransactions();

  Future<Either> addNewTransactions({
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  });

  Future<Either> editTransactions({
    required String transactionId,
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  });

  Future<Either> deleteTransactions({
    required String transactionId,
  });
}
