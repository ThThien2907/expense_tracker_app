import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class AddNewBudget extends UseCase<Either, AddNewBudgetParams> {
  final BudgetRepository budgetRepository;

  AddNewBudget(this.budgetRepository);

  @override
  Future<Either> call({AddNewBudgetParams? params}) async {
    final response = await budgetRepository.addNewBudget(
      categoryId: params!.categoryId,
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

class AddNewBudgetParams {
  final String categoryId;
  final double amountLimit;
  final DateTime startDate;
  final DateTime endDate;

  AddNewBudgetParams({
    required this.categoryId,
    required this.amountLimit,
    required this.startDate,
    required this.endDate,
  });
}
