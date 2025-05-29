import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class EditBudget extends UseCase<Either, EditBudgetParams> {
  final BudgetRepository budgetRepository;

  EditBudget(this.budgetRepository);

  @override
  Future<Either> call({EditBudgetParams? params}) async {
    final response = await budgetRepository.editBudget(
      budgetId: params!.budgetId,
      categoryId: params.categoryId,
      amountLimit: params.amountLimit,
      startDate: params.startDate,
      endDate: params.endDate,
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

class EditBudgetParams {
  final String budgetId;
  final String categoryId;
  final double amountLimit;
  final DateTime startDate;
  final DateTime endDate;

  EditBudgetParams({
    required this.budgetId,
    required this.categoryId,
    required this.amountLimit,
    required this.startDate,
    required this.endDate,
  });
}
