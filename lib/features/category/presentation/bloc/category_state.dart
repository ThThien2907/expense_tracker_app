part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

final class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> categoriesExpense;
  final List<CategoryEntity> categoriesIncome;
  final String errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categoriesExpense = const [],
    this.categoriesIncome = const [],
    this.errorMessage = '',
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categoriesExpense,
    List<CategoryEntity>? categoriesIncome,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categoriesExpense: categoriesExpense ?? this.categoriesExpense,
      categoriesIncome: categoriesIncome ?? this.categoriesIncome,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, categoriesExpense, categoriesIncome, errorMessage];
}
