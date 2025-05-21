import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class DeleteBudget extends UseCase<Either, DeleteBudgetParams> {
  final BudgetRepository budgetRepository;

  DeleteBudget(this.budgetRepository);

  @override
  Future<Either> call({DeleteBudgetParams? params}) async {
    final response = await budgetRepository.deleteBudget(
      budgetId: params!.budgetId,
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

class DeleteBudgetParams {
  final String budgetId;

  DeleteBudgetParams({
    required this.budgetId,
  });
}
