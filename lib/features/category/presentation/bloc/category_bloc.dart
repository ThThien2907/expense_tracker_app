import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:expense_tracker_app/features/category/domain/use_cases/add_new_category.dart';
import 'package:expense_tracker_app/features/category/domain/use_cases/delete_category.dart';
import 'package:expense_tracker_app/features/category/domain/use_cases/edit_category.dart';
import 'package:expense_tracker_app/features/category/domain/use_cases/load_categories.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final LoadCategories _loadCategories;
  final AddNewCategory _addNewCategory;
  final EditCategory _editCategory;
  final DeleteCategory _deleteCategory;

  CategoryBloc({
    required LoadCategories loadCategories,
    required AddNewCategory addNewCategory,
    required EditCategory editCategory,
    required DeleteCategory deleteCategory,
  })  : _loadCategories = loadCategories,
        _addNewCategory = addNewCategory,
        _editCategory = editCategory,
        _deleteCategory = deleteCategory,
        super(const CategoryState()) {
    on<CategoryStarted>(_onCategoryStarted);
    on<CategoryAdded>(_onCategoryAdded);
    on<CategoryEdited>(_onCategoryEdited);
    on<CategoryRemoved>(_onCategoryRemoved);
    on<ClearCategories>(_onClearCategories);
  }

  _onCategoryStarted(
    CategoryStarted event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    final response = await _loadCategories.call();
    response.fold(
      (ifLeft) {
        emit(state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: ifLeft,
        ));
        event.completer?.completeError(ifLeft);
      },
      (ifRight) {
        List<CategoryEntity> categories = ifRight;

        List<CategoryEntity> defaultCategoriesExpense = categories
            .where((category) => category.type == 0 && category.userId.isEmpty)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        List<CategoryEntity> userCategoriesExpense = categories
            .where((category) => category.type == 0 && category.userId.isNotEmpty)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        List<CategoryEntity> defaultCategoriesIncome = categories
            .where((category) => category.type == 1)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        List<CategoryEntity> userCategoriesIncome = categories
            .where((category) => category.type == 1 && category.userId.isNotEmpty)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        emit(state.copyWith(
          status: CategoryStatus.success,
          defaultCategoriesExpense: defaultCategoriesExpense,
          userCategoriesExpense: userCategoriesExpense,
          defaultCategoriesIncome: defaultCategoriesIncome,
          userCategoriesIncome: userCategoriesIncome,
        ));
        event.completer?.complete();
      },
    );
  }

  _onCategoryEdited(
    CategoryEdited event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final response = await _editCategory.call(
      params: EditCategoryParams(
        categoryId: event.categoryId,
        name: event.name,
        iconName: event.iconName,
        color: event.color,
      ),
    );

    if (response.isLeft()) {
      final errorMessage = response.fold((ifLeft) => ifLeft, (ifRight) => null);

      emit(state.copyWith(status: CategoryStatus.failure, errorMessage: errorMessage));
    } else {
      final category = response.fold((ifLeft) => null, (ifRight) => ifRight) as CategoryEntity;

      final Completer<void> transactionCompleter = Completer();
      final Completer<void> budgetCompleter = Completer();
      event.transactionBloc.add(TransactionStarted(completer: transactionCompleter));
      event.budgetBloc.add(BudgetStarted(completer: budgetCompleter));

      try {
        await transactionCompleter.future;
        await budgetCompleter.future;
      } catch (e) {
        debugPrint('Error: $e');
      }
      if (category.type == 0) {
        int index = state.userCategoriesExpense.indexWhere((e) => e.categoryId == event.categoryId);
        state.userCategoriesExpense.removeAt(index);
        state.userCategoriesExpense.insert(index, category);
      } else {
        int index = state.userCategoriesIncome.indexWhere((e) => e.categoryId == event.categoryId);
        state.userCategoriesIncome.removeAt(index);
        state.userCategoriesIncome.insert(index, category);
      }

      emit(state.copyWith(status: CategoryStatus.success));
    }
  }

  _onCategoryAdded(
    CategoryAdded event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final response = await _addNewCategory.call(
      params: AddNewCategoryParams(
        name: event.name,
        iconName: event.iconName,
        color: event.color,
        type: event.type,
      ),
    );

    response.fold(
      (ifLeft) {
        emit(state.copyWith(status: CategoryStatus.failure, errorMessage: ifLeft));
      },
      (ifRight) {
        final category = ifRight as CategoryEntity;
        if (category.type == 0) {
          state.userCategoriesExpense.insert(0, category);
        } else {
          state.userCategoriesIncome.insert(0, category);
        }
        emit(state.copyWith(status: CategoryStatus.success));
      },
    );
  }

  _onCategoryRemoved(
    CategoryRemoved event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final response = await _deleteCategory.call(
      params: DeleteCategoryParams(
        categoryId: event.categoryId,
      ),
    );

    if (response.isLeft()) {
      final errorMessage = response.fold((ifLeft) => ifLeft, (ifRight) => null);

      emit(state.copyWith(status: CategoryStatus.failure, errorMessage: errorMessage));
    } else {
      final Completer<void> transactionCompleter = Completer();
      final Completer<void> budgetCompleter = Completer();
      final Completer<void> walletCompleter = Completer();

      event.transactionBloc.add(TransactionStarted(completer: transactionCompleter));
      event.budgetBloc.add(BudgetStarted(completer: budgetCompleter));
      event.walletBloc.add(WalletStarted(completer: walletCompleter));

      try {
        await transactionCompleter.future;
        await budgetCompleter.future;
        await walletCompleter.future;
      } catch (e) {
        debugPrint('Error: $e');
      }

      state.userCategoriesExpense.removeWhere((e) => e.categoryId == event.categoryId);
      state.userCategoriesIncome.removeWhere((e) => e.categoryId == event.categoryId);

      emit(state.copyWith(status: CategoryStatus.success));
    }
  }

  _onClearCategories(ClearCategories event, Emitter<CategoryState> emit) {
    emit(state.copyWith(
      status: CategoryStatus.initial,
      userCategoriesExpense: [],
      userCategoriesIncome: [],
      errorMessage: '',
    ));
  }
}
