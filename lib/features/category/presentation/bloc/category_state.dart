part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

final class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> defaultCategoriesExpense;
  final List<CategoryEntity> userCategoriesExpense;
  final List<CategoryEntity> defaultCategoriesIncome;
  final List<CategoryEntity> userCategoriesIncome;
  final String errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.defaultCategoriesExpense = const [],
    this.userCategoriesExpense = const [],
    this.defaultCategoriesIncome = const [],
    this.userCategoriesIncome = const [],
    this.errorMessage = '',
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? defaultCategoriesExpense,
    List<CategoryEntity>? userCategoriesExpense,
    List<CategoryEntity>? defaultCategoriesIncome,
    List<CategoryEntity>? userCategoriesIncome,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      defaultCategoriesExpense: defaultCategoriesExpense ?? this.defaultCategoriesExpense,
      userCategoriesExpense: userCategoriesExpense ?? this.userCategoriesExpense,
      defaultCategoriesIncome: defaultCategoriesIncome ?? this.defaultCategoriesIncome,
      userCategoriesIncome: userCategoriesIncome ?? this.userCategoriesIncome,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        defaultCategoriesExpense,
        userCategoriesExpense,
        defaultCategoriesIncome,
        userCategoriesIncome,
        errorMessage,
      ];
}
