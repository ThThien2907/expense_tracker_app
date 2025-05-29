import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/transaction/data/data_sources/transaction_remote_datasource.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource transactionRemoteDatasource;

  TransactionRepositoryImpl(this.transactionRemoteDatasource);

  @override
  Future<Either> loadTransactions() async {
    final response = await transactionRemoteDatasource.loadTransactions(
    );

    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> addNewTransactions({
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  }) async {
    final response = await transactionRemoteDatasource.addNewTransaction(
      categoryId: categoryId,
      walletId: walletId,
      amount: amount,
      description: description,
      createdAt: createdAt,
    );

    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> deleteTransactions({required String transactionId}) async {
    final response = await transactionRemoteDatasource.deleteTransaction(
      transactionId: transactionId,
    );

    return response.fold(
          (ifLeft) {
        return Left(ifLeft);
      },
          (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> editTransactions({
    required String transactionId,
    required String categoryId,
    required String walletId,
    required double amount,
    required String description,
    required DateTime createdAt,
  }) async {
    final response = await transactionRemoteDatasource.editTransaction(
      transactionId: transactionId,
      categoryId: categoryId,
      walletId: walletId,
      amount: amount,
      description: description,
      createdAt: createdAt,
    );

    return response.fold(
          (ifLeft) {
        return Left(ifLeft);
      },
          (ifRight) {
        return Right(ifRight);
      },
    );
  }
}
