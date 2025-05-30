import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class LoadBudgets extends UseCase<Either, NoParams> {
  final BudgetRepository budgetRepository;

  LoadBudgets(this.budgetRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    final response = await budgetRepository.loadBudgets();

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
