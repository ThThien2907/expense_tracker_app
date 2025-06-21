import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_app/features/transaction/data/data_sources/transaction_remote_datasource.dart';
import 'package:expense_tracker_app/features/transaction/data/models/transaction_model.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker_app/features/wallet/data/models/wallet_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource transactionRemoteDatasource;

  TransactionRepositoryImpl(this.transactionRemoteDatasource);

  @override
  Future<Either> loadTransactions() async {
    final response = await transactionRemoteDatasource.loadTransactions();

    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        List<Map<String, dynamic>> response = ifRight;
        return Right(response.map((e) => TransactionModel.fromMap(e)).toList());
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
        Map<String, dynamic> response = ifRight;
        final newTransaction = TransactionModel.fromMap(response['transaction']);
        final wallet = WalletModel.fromMap(response['wallet']);
        final budgets = response['budgets'] != null
            ? (response['budgets'] as List).map((e) => BudgetModel.fromMap(e)).toList()
            : null;
        return Right(<String, dynamic>{
          'transaction': newTransaction,
          'wallet': wallet,
          'budgets': budgets,
        });
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
        Map<String, dynamic> response = ifRight;
        final wallet = WalletModel.fromMap(response['wallet']);
        final budgets = response['budgets'] != null
            ? (response['budgets'] as List).map((e) => BudgetModel.fromMap(e)).toList()
            : null;
        return Right(<String, dynamic>{
          'wallet': wallet,
          'budgets': budgets,
        });
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
        Map<String, dynamic> response = ifRight;
        final newTransaction = TransactionModel.fromMap(response['transaction']);
        final oldWallet = WalletModel.fromMap(response['old_wallet']);
        final newWallet = WalletModel.fromMap(response['new_wallet']);
        final oldBudgets = response['old_budgets'] != null
            ? (response['old_budgets'] as List).map((e) => BudgetModel.fromMap(e)).toList()
            : null;
        final newBudgets = response['new_budgets'] != null
            ? (response['new_budgets'] as List).map((e) => BudgetModel.fromMap(e)).toList()
            : null;
        return Right(<String, dynamic>{
          'transaction': newTransaction,
          'old_wallet': oldWallet,
          'new_wallet': newWallet,
          'old_budgets': oldBudgets,
          'new_budgets': newBudgets,
        });
      },
    );
  }
}
