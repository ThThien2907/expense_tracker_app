import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/budget/data/data_sources/budget_remote_datasource.dart';
import 'package:expense_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDatasource budgetRemoteDatasource;

  BudgetRepositoryImpl(this.budgetRemoteDatasource);

  @override
  Future<Either> addNewBudget({
    required String userId,
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await budgetRemoteDatasource.addNewBudget(
      userId: userId,
      categoryId: categoryId,
      amountLimit: amountLimit,
      startDate: startDate,
      endDate: endDate,
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
  Future<Either> deleteBudget({required String budgetId}) async {
    final response = await budgetRemoteDatasource.deleteBudget(
      budgetId: budgetId,
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
  Future<Either> editBudget({
    required String budgetId,
    required String userId,
    required String categoryId,
    required double amountLimit,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await budgetRemoteDatasource.editBudget(
      budgetId: budgetId,
      userId: userId,
      categoryId: categoryId,
      amountLimit: amountLimit,
      startDate: startDate,
      endDate: endDate,
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
  Future<Either> loadBudgets({required String userId}) async {
    final response = await budgetRemoteDatasource.loadBudgets(
      userId: userId,
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
