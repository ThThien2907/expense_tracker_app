import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/features/category/domain/entities/category_entity.dart';
import 'package:expense_tracker_app/features/category/domain/use_cases/load_categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final LoadCategories _loadCategories;

  CategoryBloc({
    required LoadCategories loadCategories,
  })  : _loadCategories = loadCategories,
        super(const CategoryState()) {
    on<CategoryStarted>(_onCategoryStarted);
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
      },
      (ifRight) {
        List<CategoryEntity> categories = ifRight;
        List<CategoryEntity> categoriesExpense = categories
            .where((category) => category.type == 0)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        List<CategoryEntity> categoriesIncome = categories
            .where((category) => category.type == 1)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        emit(state.copyWith(
          status: CategoryStatus.success,
          categoriesExpense: categoriesExpense,
          categoriesIncome: categoriesIncome,
        ));
      },
    );
  }
}
