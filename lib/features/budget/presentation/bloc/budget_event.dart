part of 'budget_bloc.dart';

sealed class BudgetEvent extends Equatable {
  const BudgetEvent();
}

final class BudgetStarted extends BudgetEvent {
  final String userId;

  const BudgetStarted({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final class BudgetAdded extends BudgetEvent {
  final String userId;
  final String categoryId;
  final double amountLimit;
  final DateTime startDate;
  final DateTime endDate;

  const BudgetAdded({
    required this.userId,
    required this.categoryId,
    required this.amountLimit,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props =>
      [userId, categoryId, amountLimit, startDate, endDate];
}

final class BudgetEdited extends BudgetEvent {
  final String budgetId;
  final String userId;
  final String categoryId;
  final double amountLimit;
  final DateTime startDate;
  final DateTime endDate;

  const BudgetEdited({
    required this.budgetId,
    required this.userId,
    required this.categoryId,
    required this.amountLimit,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props =>
      [budgetId, userId, categoryId, amountLimit, startDate, endDate];
}

final class BudgetRemoved extends BudgetEvent {
  final String budgetId;

  const BudgetRemoved({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}
