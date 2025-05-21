part of 'budget_bloc.dart';

enum BudgetStatus { initial, loading, success, failure }

final class BudgetState extends Equatable {
  final BudgetStatus status;
  final List<BudgetEntity> budgets;
  final String errorMessage;

  const BudgetState({
    this.status = BudgetStatus.initial,
    this.budgets = const [],
    this.errorMessage = '',
  });

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetEntity>? budgets,
    String? errorMessage,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, budgets, errorMessage];
}
