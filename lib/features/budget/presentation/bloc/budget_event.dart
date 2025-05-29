part of 'budget_bloc.dart';

sealed class BudgetEvent extends Equatable {
  const BudgetEvent();
}

final class BudgetStarted extends BudgetEvent {
  final Completer<void>? completer;

  const BudgetStarted({this.completer});

  @override
  List<Object?> get props => [completer];
}

final class BudgetAdded extends BudgetEvent {
  final String categoryId;
  final double amountLimit;
  final DateTime startDate;
  final DateTime endDate;

  const BudgetAdded({
    required this.categoryId,
    required this.amountLimit,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props =>
      [categoryId, amountLimit, startDate, endDate];
}

final class BudgetEdited extends BudgetEvent {
  final String budgetId;
  final String categoryId;
  final double amountLimit;
  final DateTime startDate;
  final DateTime endDate;

  const BudgetEdited({
    required this.budgetId,
    required this.categoryId,
    required this.amountLimit,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props =>
      [budgetId, categoryId, amountLimit, startDate, endDate];
}

final class BudgetRemoved extends BudgetEvent {
  final String budgetId;

  const BudgetRemoved({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

final class BudgetChanged extends BudgetEvent {
  final List<dynamic> data;

  const BudgetChanged({required this.data});

  @override
  List<Object?> get props => [data];
}

final class ClearBudgets extends BudgetEvent {
  @override
  List<Object?> get props => [];
}
