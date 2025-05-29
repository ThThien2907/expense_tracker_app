import 'package:dartz/dartz.dart';

abstract class BudgetRepository {
  Future<Either> loadBudgets();

  Future<Either> addNewBudget({
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either> editBudget({
    required String budgetId,
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either> deleteBudget({
    required String budgetId,
  });
}