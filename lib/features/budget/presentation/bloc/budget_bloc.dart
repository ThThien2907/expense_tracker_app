import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/add_new_budget.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/delete_budget.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/edit_budget.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/load_budgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budget_event.dart';

part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final LoadBudgets _loadBudgets;
  final AddNewBudget _addNewBudget;
  final EditBudget _editBudget;
  final DeleteBudget _deleteBudget;

  BudgetBloc({
    required LoadBudgets loadBudgets,
    required AddNewBudget addNewBudget,
    required EditBudget editBudget,
    required DeleteBudget deleteBudget,
  })  : _loadBudgets = loadBudgets,
        _addNewBudget = addNewBudget,
        _editBudget = editBudget,
        _deleteBudget = deleteBudget,
        super(const BudgetState()) {
    on<BudgetStarted>(_onBudgetStarted);
    on<BudgetAdded>(_onBudgetAdded);
    on<BudgetEdited>(_onBudgetEdited);
    on<BudgetRemoved>(_onBudgetRemoved);
    on<BudgetChanged>(_onBudgetChanged);
    on<ClearBudgets>(_onClearBudgets);
  }

  _onBudgetStarted(
    BudgetStarted event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    var response = await _loadBudgets.call();

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: BudgetStatus.failure,
          errorMessage: ifLeft,
        ));
        event.completer?.completeError(ifLeft);
      },
      (ifRight) {
        emit(state.copyWith(
          status: BudgetStatus.success,
          budgets: ifRight,
          errorMessage: '',
        ));
        event.completer?.complete();
      },
    );
  }

  _onBudgetAdded(
    BudgetAdded event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    var response = await _addNewBudget.call(
      params: AddNewBudgetParams(
        categoryId: event.categoryId,
        amountLimit: event.amountLimit,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: BudgetStatus.failure,
          errorMessage: ifLeft,
        ));
      },
      (ifRight) {
        final budget = ifRight as BudgetEntity;
        state.budgets.insert(0, budget);

        emit(state.copyWith(
          status: BudgetStatus.success,
          errorMessage: '',
        ));

        if (budget.amountSpent - budget.amountLimit > 0) {
          emit(state.copyWith(
            status: BudgetStatus.exceeded,
            budgetExceeded: budget,
          ));
        }
      },
    );
  }

  _onBudgetEdited(
    BudgetEdited event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    var response = await _editBudget.call(
      params: EditBudgetParams(
        budgetId: event.budgetId,
        categoryId: event.categoryId,
        amountLimit: event.amountLimit,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: BudgetStatus.failure,
          errorMessage: ifLeft,
        ));
      },
      (ifRight) {
        int index = state.budgets.indexWhere((budget) => budget.budgetId == event.budgetId);
        state.budgets.removeAt(index);
        final budget = ifRight as BudgetEntity;
        state.budgets.insert(index, budget);
        emit(state.copyWith(
          status: BudgetStatus.success,
          errorMessage: '',
        ));
        if (budget.amountSpent - budget.amountLimit > 0) {
          emit(state.copyWith(
            status: BudgetStatus.exceeded,
            budgetExceeded: budget,
          ));
        }
      },
    );
  }

  _onBudgetRemoved(
    BudgetRemoved event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    var response = await _deleteBudget.call(
      params: DeleteBudgetParams(
        budgetId: event.budgetId,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: BudgetStatus.failure,
          errorMessage: ifLeft,
        ));
      },
      (ifRight) {
        state.budgets.removeWhere((budget) => budget.budgetId == event.budgetId);
        emit(state.copyWith(
          status: BudgetStatus.success,
          errorMessage: '',
        ));
      },
    );
  }

  _onBudgetChanged(
    BudgetChanged event,
    Emitter<BudgetState> emit,
  ) {
    emit(state.copyWith(status: BudgetStatus.loading));
    for (var budget in event.budgets) {
      state.budgets.firstWhere((e) => e.budgetId == budget.budgetId).amountSpent =
          (budget.amountSpent as num).toDouble();
    }
    emit(state.copyWith(status: BudgetStatus.success));

    for (var budget in event.budgets) {
      final budgetExceeded = state.budgets.firstWhere((e) => e.budgetId == budget.budgetId);
      if (budgetExceeded.amountSpent - budgetExceeded.amountLimit > 0) {
        emit(state.copyWith(
          status: BudgetStatus.exceeded,
          budgetExceeded: budgetExceeded,
        ));
        break;
      }
    }
  }

  _onClearBudgets(
    ClearBudgets event,
    Emitter<BudgetState> emit,
  ) {
    emit(state.copyWith(
      status: BudgetStatus.initial,
      budgets: const [],
      errorMessage: '',
    ));
  }
}
