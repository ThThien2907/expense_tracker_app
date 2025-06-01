part of 'budget_bloc.dart';

enum BudgetStatus { initial, loading, success, failure, exceeded }

final class BudgetState extends Equatable {
  final BudgetStatus status;
  final List<BudgetEntity> budgets;
  final String errorMessage;
  final BudgetEntity? budgetExceeded;

  const BudgetState({
    this.status = BudgetStatus.initial,
    this.budgets = const [],
    this.errorMessage = '',
    this.budgetExceeded,
  });

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetEntity>? budgets,
    String? errorMessage,
    BudgetEntity? budgetExceeded,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
      budgetExceeded: budgetExceeded ?? this.budgetExceeded,
    );
  }

  @override
  List<Object?> get props => [status, budgets, errorMessage, budgetExceeded];
}
